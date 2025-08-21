import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/auth/domain/repositories/auth_repository.dart';

import 'package:instagram/features/auth/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  // ignore: unused_field
  late StreamSubscription<User?> _userSubscription;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  void startListeningToAuthChanges() {
    _userSubscription = authRepository.userChanges.listen((user) {
      if (user == null) {
        emit(AuthInitial());
      } else {
        emit(AuthSuccess(isEmailVerified: user.emailVerified));
      }
    });
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await authRepository.createUserWithEmailAndPassword(
        name,
        email,
        password,
      );
      await authRepository.verifyEmail();
      emit(AuthVerificationSent());
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await authRepository.signInWithEmailAndPassword(email, password);
      emit(
        AuthSuccess(
          isEmailVerified: await authRepository.isUserEmailVerified(),
        ),
      );
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await authRepository.forgotPassword(email);
      emit(AuthVerificationSent());
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> sendVerificationEmail() async {
    emit(AuthLoading());
    try {
      await authRepository.verifyEmail();
      emit(AuthVerificationSent());
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOutUser() async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(AuthInitial());
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
