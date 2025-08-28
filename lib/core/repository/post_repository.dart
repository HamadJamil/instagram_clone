import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/models/post_model.dart';

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
          .where('userId', isNotEqualTo: userId)
          .orderBy('userId')
          .orderBy('createdAt', descending: true)
          .limit(10);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
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
      await _firestore.collection('posts').doc(post.id).set(post.toJson()).then(
        (value) {
          _firestore.collection('users').doc(post.userId).set({
            'postCount': FieldValue.increment(1),
          }, SetOptions(merge: true));
        },
      );
    } catch (e) {
      throw Exception('FirestorePostService: Error creating post: $e');
    }
  }

  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('FirestoreProfileService :Failed to get user posts: $e');
    }
  }
}
