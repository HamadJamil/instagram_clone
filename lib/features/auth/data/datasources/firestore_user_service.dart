import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/utils/exception.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';

class FireStoreUserService {
  final FirebaseFirestore _firestore;

  FireStoreUserService(this._firestore);

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } on Exception catch (e) {
      throw FirestoreException(
        'FirestoreUserService: Failed to create user: ${e.toString()}',
      );
    }
  }
}
