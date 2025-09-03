import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/models/comment_model.dart';
import 'package:instagram/core/models/user_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore;

  CommentRepository(this._firestore);

  Stream<List<Comment>> getCommentsStream({
    required String postId,
    int limit = 15,
    DocumentSnapshot? lastDocument,
  }) {
    try {
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
    } catch (e) {
      throw Exception(
        'Unable to load comments. Please check your internet connection and try again.',
      );
    }
  }

  Future<void> addComment({
    required String postId,
    required Comment comment,
  }) async {
    try {
      final batch = _firestore.batch();

      final commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(comment.id);
      batch.set(commentRef, comment.toJson());

      final postRef = _firestore.collection('posts').doc(postId);
      batch.update(postRef, {'comments': FieldValue.increment(1)});

      await batch.commit();
    } catch (e) {
      throw Exception(
        'Could not post your comment. Please check your connection and try again.',
      );
    }
  }

  Future<void> deleteComments(String postId) async {
    try {
      final batch = _firestore.batch();

      final commentsRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments');
      final snapshot = await commentsRef.get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception(
        'Could not delete comments. Please check your connection and try again.',
      );
    }
  }

  Future<List<Comment>> loadMoreComments({
    required String postId,
    required DocumentSnapshot lastDocument,
    int limit = 10,
  }) async {
    try {
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
    } catch (e) {
      throw Exception('Failed to load more comments. Please try again later.');
    }
  }

  Future<DocumentSnapshot?> getLastDocument({
    required String postId,
    int limit = 15,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: false)
          .limit(limit)
          .get();

      return snapshot.docs.length == limit ? snapshot.docs.last : null;
    } catch (e) {
      throw Exception(
        'Could not retrieve comment information. Please try again.',
      );
    }
  }

  Future<void> updateAuthorDetails(UserModel updatedUser) async {
    try {
      final posts = await _firestore.collection('posts').get();
      final batch = _firestore.batch();

      for (final postDoc in posts.docs) {
        final commentsQuery = await postDoc.reference
            .collection('comments')
            .where('authorId', isEqualTo: updatedUser.uid)
            .get();

        for (final commentDoc in commentsQuery.docs) {
          batch.update(commentDoc.reference, {
            'authorName': updatedUser.name,
            'authorAvatar': updatedUser.photoUrl,
          });
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception(
        'Unable to update author details in comments. Please try again.',
      );
    }
  }
}
