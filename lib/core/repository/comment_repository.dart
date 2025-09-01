import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/models/comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore;

  CommentRepository(this._firestore);

  Stream<List<Comment>> getCommentsStream({
    required String postId,
    int limit = 15,
    DocumentSnapshot? lastDocument,
  }) {
    var query = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Comment.fromJson(doc.data());
      }).toList();
    });
  }

  Future<void> addComment({
    required String postId,
    required Comment comment,
  }) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment.id)
        .set(comment.toJson());

    await _firestore.collection('posts').doc(postId).update({
      'comments': FieldValue.increment(1),
    });
  }

  Future<List<Comment>> loadMoreComments({
    required String postId,
    required DocumentSnapshot lastDocument,
    int limit = 10,
  }) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return Comment.fromJson(doc.data());
    }).toList();
  }

  Future<DocumentSnapshot?> getLastDocument({
    required String postId,
    int limit = 15,
  }) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .limit(limit)
        .get();

    return snapshot.docs.length == limit ? snapshot.docs.last : null;
  }
}
