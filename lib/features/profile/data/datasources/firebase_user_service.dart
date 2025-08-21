import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserService {
  final FirebaseAuth _firebaseAuth;

  FirebaseUserService() : _firebaseAuth = FirebaseAuth.instance;

  Future<String?> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser?.uid;
    } catch (e) {
      throw Exception('FirebaseUserService Failed To get current user ID: $e');
    }
  }
}
