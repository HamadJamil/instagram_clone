import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/utils/exception.dart';
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
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(
        'FirebaseAuthService: Network error: ${e.message}',
      );
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(
        'FirebaseAuthService: Network error: ${e.message}',
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(
        'FirebaseAuthService: Network error: ${e.message}',
      );
    }
  }

  Future<void> emailVerification() async {
    try {
      if (_auth.currentUser == null) {
        throw AuthException(
          'FirebaseAuthService: No user is currently signed in',
        );
      }
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(
        'FirebaseAuthService: Network error: ${e.message}',
      );
    }
  }

  Future<void> signOut() async {
    if (_auth.currentUser == null) {
      throw AuthException(
        'FirebaseAuthService: No user is currently signed in',
      );
    }
    await _auth.signOut();
  }

  Future<bool> isUserEmailVerified() async {
    try {
      if (_auth.currentUser == null) {
        throw AuthException(
          'FirebaseAuthService: No user is currently signed in',
        );
      }
      await _auth.currentUser?.reload();
      return _auth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code), code: e.code);
    } on SocketException catch (e) {
      throw NetworkException(
        'FirebaseAuthService: Network error: ${e.message}',
      );
    }
  }
}
