import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSearchService {
  final FirebaseFirestore _firestore;

  FirestoreSearchService(this._firestore);

  Future<QuerySnapshot<Map<String, dynamic>>> searchUsers() async {
    try {
      return await _firestore.collection('users').limit(100).get();
    } catch (e) {
      throw Exception('FirestoreSearchService: Failed to search users: $e');
    }
  }
}
