import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  //Create User
  Future<void> createUserWithEmailAndPassword(
    String userName,
    String email,
    String password,
  );
  //User Verified
  Future<bool> isUserEmailVerified();
  //Forgot Password
  Future<void> forgotPassword(String email);
  //Verify Email
  Future<void> verifyEmail();
  //Sign In User
  Future<void> signInWithEmailAndPassword(String email, String password);
  //Sign Out User
  Future<void> signOut();
  //Stream
  Stream<User?> get userChanges;
}
