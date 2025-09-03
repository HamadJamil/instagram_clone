import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/repository/user_repository.dart';
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
  }

  @override
  Future<void> forgotPassword(String email) async {
    _firebaseAuthService.resetPassword(email);
  }

  @override
  Future<void> verifyEmail() async {
    await _firebaseAuthService.emailVerification();
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuthService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }
}
