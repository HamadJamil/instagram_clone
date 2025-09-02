import 'package:equatable/equatable.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/models/user_model.dart';

abstract class OtherUserProfileState extends Equatable {
  const OtherUserProfileState();

  @override
  List<Object> get props => [];
}

class OtherUserProfileInitial extends OtherUserProfileState {}

class OtherUserProfileLoading extends OtherUserProfileState {}

class OtherUserProfileLoaded extends OtherUserProfileState {
  final UserModel user;
  final List<PostModel> posts;
  final bool isFollowing;

  const OtherUserProfileLoaded({
    required this.user,
    required this.posts,
    required this.isFollowing,
  });

  @override
  List<Object> get props => [user, posts, isFollowing];
}

class OtherUserProfileError extends OtherUserProfileState {
  final String message;

  const OtherUserProfileError(this.message);

  @override
  List<Object> get props => [message];
}
