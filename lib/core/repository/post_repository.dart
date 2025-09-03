import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/models/user_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository(this._firestore);

  Stream<List<PostModel>> getPostsStream({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) {
    try {
      var query = _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return PostModel.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      throw Exception(
        'Unable to load posts. Please check your internet connection and try again.',
      );
    }
  }

  Future<List<PostModel>> loadMorePosts({
    required DocumentSnapshot lastDocument,
    int limit = 10,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        return PostModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      throw Exception('Failed to load more posts. Please try again later.');
    }
  }

  Future<DocumentSnapshot?> getLastDocument({int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.length == limit ? snapshot.docs.last : null;
    } catch (e) {
      throw Exception('Could not retrieve post information. Please try again.');
    }
  }

  Future<void> create(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Unable to create your post. ');
    }
  }

  Future<void> delete(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw Exception('Could not delete the post. ');
    }
  }

  Future<void> update(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).update(post.toJson());
    } catch (e) {
      throw Exception('Unable to update your post. ');
    }
  }

  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('posts')
          .where('authorId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(
        'Could not load user posts. Please try refreshing the page.',
      );
    }
  }

  Future<void> updateAuthorDetails(UserModel updatedUser) async {
    try {
      final batch = _firestore.batch();

      final postRef = _firestore
          .collection('posts')
          .where('authorId', isEqualTo: updatedUser.uid);

      final snapshot = await postRef.get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {
          'authorName': updatedUser.name,
          'authorAvatar': updatedUser.photoUrl,
        });
      }
      await batch.commit();
    } catch (e) {
      throw Exception(
        'Unable to update profile information across posts. Please try again.',
      );
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('Could not like the post. ');
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('Could not unlike the post. Please try again.');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> postStream(String postId) {
    try {
      return _firestore.collection('posts').doc(postId).snapshots();
    } catch (e) {
      throw Exception(
        'Unable to load post details. Please check your connection.',
      );
    }
  }
}
