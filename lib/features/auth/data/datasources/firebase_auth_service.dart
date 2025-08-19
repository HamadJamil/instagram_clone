import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/utils/exception.dart';
import 'package:instagram/core/utils/utils.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<void> emailVerification() async {
    try {
      if (_auth.currentUser == null) {
        throw AuthException('No user is currently signed in');
      }
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }

  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  Future<void> signOut() async {
    if (_auth.currentUser == null) {
      throw AuthException('No user is currently signed in');
    }
    await _auth.signOut();
  }

  Future<bool> isUserEmailVerified() async {
    try {
      if (_auth.currentUser == null) {
        throw AuthException('No user is currently signed in');
      }
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    }
  }
}
