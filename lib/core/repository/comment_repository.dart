import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/models/comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore;
  final Map<String, DocumentSnapshot> _lastDocuments = {};
  final Map<String, List<Comment>> _allComments = {};

  CommentRepository(this._firestore);

  Future<List<Comment>> getComments({
    required String postId,
    required int page,
    required int pageSize,
  }) async {
    if (page == 1) {
      _lastDocuments.remove(postId);
      _allComments.remove(postId);
    }

    try {
      Query query = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .limit(pageSize);

      final lastDoc = _lastDocuments[postId];
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocuments[postId] = snapshot.docs.last;
      }

      final newComments = snapshot.docs.map((doc) {
        return Comment.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      if (_allComments[postId] == null) {
        _allComments[postId] = [];
      }
      _allComments[postId]!.addAll(newComments);

      return _allComments[postId]!;
    } catch (e) {
      throw Exception(
        'FirestoreCommentsRepository: Error fetching comments: $e',
      );
    }
  }

  bool hasMore(String postId) => _lastDocuments[postId] != null;

  void resetPagination(String postId) {
    _lastDocuments.remove(postId);
    _allComments.remove(postId);
  }

  Future<Comment> addComment({
    required String postId,
    required String text,
    required String userId,
    required String userName,
    required String userAvatar,
  }) async {
    try {
      // Reference to the comments subcollection
      final commentsRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc();

      final comment = Comment(
        id: commentsRef.id,
        authorId: userId,
        authorName: userName,
        authorAvatar: userAvatar,
        text: text,
        createdAt: DateTime.now(),
      );

      await commentsRef.set(comment.toJson());

      // Update post comments count in main post document
      await _firestore.collection('posts').doc(postId).update({
        'commentsCount': FieldValue.increment(1),
      });

      return comment;
    } catch (e) {
      throw Exception('FirestoreCommentsRepository: Error adding comment: $e');
    }
  }

  Stream<QuerySnapshot> getCommentsStream(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
