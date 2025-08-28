import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/core/utils/exceptions.dart';
import 'package:instagram/features/auth/data/datasources/firebase_auth_service.dart';
import 'package:instagram/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final UserRepository _userRepository;

  AuthRepositoryImplementation(this._firebaseAuthService, this._userRepository);

  @override
  Stream<User?> get userChanges => _firebaseAuthService.userChanges;

  @override
  Future<bool> isUserEmailVerified() async {
    try {
      return await _firebaseAuthService.isUserEmailVerified();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
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
        await _userRepository.create(userModel);
      }
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
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuthService.signInWithEmailAndPassword(email, password);
    } on AuthException {
      rethrow;
    } on NetworkException {
      rethrow;
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw Exception('AuthRepo Sigin Failed $e');
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
