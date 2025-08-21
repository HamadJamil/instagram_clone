import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';

class FirestorePostService {
  final FirebaseFirestore _firestore;

  FirestorePostService() : _firestore = FirebaseFirestore.instance;

  Future<void> createPost(PostModel post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('FirestorePostService: Error creating post: $e');
    }
  }
}
