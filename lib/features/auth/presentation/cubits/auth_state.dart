import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final bool isEmailVerified;
  const AuthSuccess({this.isEmailVerified = false});

  @override
  List<Object> get props => [isEmailVerified];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthVerificationSent extends AuthState {}
