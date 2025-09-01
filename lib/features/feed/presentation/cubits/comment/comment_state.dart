import 'package:equatable/equatable.dart';
import 'package:instagram/core/models/comment_model.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<Comment> comments;
  final bool hasMore;

  const CommentLoaded({required this.comments, required this.hasMore});

  @override
  List<Object> get props => [comments, hasMore];
}

class CommentLoadingMore extends CommentState {
  final List<Comment> currentComments;
  final bool hasMore;

  const CommentLoadingMore({
    required this.currentComments,
    required this.hasMore,
  });

  @override
  List<Object> get props => [currentComments, hasMore];
}

class CommentAdding extends CommentState {
  final List<Comment> currentComments;
  final bool hasMore;

  const CommentAdding(this.currentComments, this.hasMore);

  @override
  List<Object> get props => [currentComments, hasMore];
}

class CommentDeleting extends CommentState {
  final List<Comment> currentComments;
  final bool hasMore;

  const CommentDeleting(this.currentComments, this.hasMore);

  @override
  List<Object> get props => [currentComments, hasMore];
}

class CommentError extends CommentState {
  final String message;

  const CommentError(this.message);

  @override
  List<Object> get props => [message];
}
