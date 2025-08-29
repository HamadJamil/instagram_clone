import 'package:equatable/equatable.dart';

abstract class LikeState extends Equatable {
  const LikeState();

  @override
  List<Object> get props => [];
}

class LikeInitial extends LikeState {}

class LikeLoading extends LikeState {}

class LikeLoaded extends LikeState {
  final bool isLiked;
  final int likesCount;

  const LikeLoaded({required this.isLiked, required this.likesCount});

  @override
  List<Object> get props => [isLiked, likesCount];
}

class LikeError extends LikeState {
  final String message;

  const LikeError(this.message);

  @override
  List<Object> get props => [message];
}
