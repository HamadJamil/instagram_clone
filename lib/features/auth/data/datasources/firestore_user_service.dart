import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/utils/exception.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';

class FireStoreUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } on Exception catch (e) {
      throw FirestoreException(
        'Firestore: Failed to create user: ${e.toString()}',
      );
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists
          ? UserModel.fromJson(doc.data()!)
          : throw FirestoreException('Firestore: User not found');
    } on Exception catch (e) {
      throw FirestoreException(
        'Firestore: Failed to fetch user: ${e.toString()}',
      );
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toJson());
    } on Exception catch (e) {
      throw FirestoreException(
        'Firestore: Failed to update user: ${e.toString()}',
      );
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } on Exception catch (e) {
      throw FirestoreException(
        'Firestore: Failed to delete user: ${e.toString()}',
      );
    }
  }

  Stream<UserModel?> userStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      return doc.exists ? UserModel.fromJson(doc.data()!) : null;
    });
  }
}
