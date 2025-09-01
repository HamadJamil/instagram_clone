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
  }

  Future<List<PostModel>> loadMorePosts({
    required DocumentSnapshot lastDocument,
    int limit = 10,
  }) async {
    final snapshot = await _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return PostModel.fromJson(doc.data());
    }).toList();
  }

  Future<DocumentSnapshot?> getLastDocument({int limit = 10}) async {
    final snapshot = await _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.length == limit ? snapshot.docs.last : null;
  }

  Future<void> create(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('FirestorePostService: Error creating post: $e');
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
      throw Exception('FirestoreProfileService :Failed to get user posts: $e');
    }
  }

  Future<void> changeAuthorDetails(UserModel updatedUser) async {
    try {
      final references = await _firestore
          .collection('posts')
          .where('authorId', isEqualTo: updatedUser.uid)
          .get();
      for (var doc in references.docs) {
        await doc.reference.update({
          'authorName': updatedUser.name,
          'authorImage': updatedUser.photoUrl,
        });
      }
    } catch (e) {
      throw Exception(
        'FirestorePostService: Error changing author details: $e',
      );
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw Exception('FirestorePostService: Error liking post: $e');
    }
  }

  Future<void> unlikePost(String postId, String userId) async {
    try {
      await _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw Exception('FirestorePostService: Error unliking post: $e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> postStream(String postId) {
    return _firestore.collection('posts').doc(postId).snapshots();
  }
}
