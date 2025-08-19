import 'package:instagram/core/utils/exception.dart';
import 'package:instagram/features/auth/data/datasources/firebase_auth_service.dart';
import 'package:instagram/features/auth/data/datasources/firestore_user_service.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';
import 'package:instagram/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FireStoreUserService _fireStoreUserService;

  AuthRepositoryImplementation(
    this._firebaseAuthService,
    this._fireStoreUserService,
  );

  @override
  Future<bool> isUserEmailVerified() async {
    try {
      return await _firebaseAuthService.isUserEmailVerified();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _firebaseAuthService.isLoggedIn();
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
    String userName,
    String email,
    String password,
  ) async {
    try {
      final user = await _firebaseAuthService.createUserWithEmailAndPassword(
        email,
        password,
      );
      final userModel = UserModel(
        uid: (user?.user?.uid)!,
        email: email,
        name: userName,
      );
      if (user != null) {
        await _fireStoreUserService.createUser(userModel);
      }
      return user != null ? userModel : null;
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      _firebaseAuthService.resetPassword(email);
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<void> verifyEmail() async {
    try {
      await _firebaseAuthService.emailVerification();
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await _firebaseAuthService.signInWithEmailAndPassword(
        email,
        password,
      );
      return user != null
          ? await _fireStoreUserService.getUser(user.user?.uid ?? '')
          : null;
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuthService.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
