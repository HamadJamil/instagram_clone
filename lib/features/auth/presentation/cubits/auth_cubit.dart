import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/auth/domain/repositories/auth_repository.dart';

import 'package:instagram/features/auth/presentation/cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> register({
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
      sendVerificationEmail();
    } on Exception catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithEmailAndPassword(
        email,
        password,
      );
      emit(AuthSuccess(user!));
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
