import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';

class FirestorePostService {
  final FirebaseFirestore _firestore;

  FirestorePostService() : _firestore = FirebaseFirestore.instance;

  Future<void> createPost(PostModel post) async {
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
}
