import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFeedService {
  final FirebaseFirestore _firestore;

  FirestoreFeedService(this._firestore);

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPosts(String userId) async {
    try {
      return await _firestore
          .collection('posts')
          .where('userId', isNotEqualTo: userId)
          .get();
    } catch (e) {
      throw Exception('FireStoreFeedService : Error fetching posts: $e');
    }
  }
}
