import 'package:instagram/features/auth/domain/entities/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
