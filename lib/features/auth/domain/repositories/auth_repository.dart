import 'package:instagram/features/auth/domain/entities/user_model.dart';

abstract class AuthRepository {
  //Check if user is logged in
  Future<bool> isLoggedIn();
  //Create User
  Future<UserModel?> createUserWithEmailAndPassword(
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
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  //Sign Out User
  Future<void> signOut();
}
