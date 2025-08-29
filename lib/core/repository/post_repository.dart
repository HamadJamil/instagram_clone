import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/models/user_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore;
  DocumentSnapshot? _lastDocument;
  List<PostModel> _allPosts = [];

  PostRepository(this._firestore);

  Future<List<PostModel>> fetch(
    String userId, {
    bool loadMore = false,
    bool refresh = false,
  }) async {
    if (refresh) {
      _lastDocument = null;
      _allPosts = [];
    }

    try {
      Query query = _firestore
          .collection('posts')
          .where('authorId', isNotEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(10);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.length == 10) {
        _lastDocument = snapshot.docs.last;
      }

      final newPosts = snapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      _allPosts.addAll(newPosts);

      return _allPosts;
    } catch (e) {
      throw Exception('FireStoreFeedService: Error fetching posts: $e');
    }
  }

  bool get hasMore => _lastDocument != null;

  void resetPagination() {
    _lastDocument = null;
    _allPosts = [];
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
