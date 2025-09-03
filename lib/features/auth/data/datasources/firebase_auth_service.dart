import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/utils/utils.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService(this._auth);

  Stream<User?> get userChanges => _auth.userChanges();

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(getMessageFromErrorCode(e.code));
    } on SocketException catch (_) {
      throw Exception('Network error: Please check your internet connection.');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(getMessageFromErrorCode(e.code));
    } on SocketException catch (_) {
      throw Exception('Network error: Please check your internet connection.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(getMessageFromErrorCode(e.code));
    } on SocketException catch (_) {
      throw Exception('Network error: Please check your internet connection.');
    }
  }

  Future<void> emailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(getMessageFromErrorCode(e.code));
    } on SocketException catch (_) {
      throw Exception('Network error: Please check your internet connection.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(getMessageFromErrorCode(e.code));
    } on SocketException catch (_) {
      throw Exception('Network error: Please check your internet connection.');
    }
  }

  Future<bool> isUserEmailVerified() async {
    try {
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      throw Exception(getMessageFromErrorCode(e.code));
    } on SocketException catch (_) {
      throw Exception('Network error: Please check your internet connection.');
    }
  }
}
