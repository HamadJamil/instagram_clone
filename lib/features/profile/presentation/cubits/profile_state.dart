import 'package:equatable/equatable.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/models/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final List<PostModel>? posts;

  ProfileLoaded({required this.user, this.posts});

  ProfileLoaded copyWith({UserModel? user, List<PostModel>? posts}) {
    return ProfileLoaded(user: user ?? this.user, posts: posts ?? this.posts);
  }

  @override
  List<Object?> get props => [user, posts];
}

class ProfileLogOut extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
