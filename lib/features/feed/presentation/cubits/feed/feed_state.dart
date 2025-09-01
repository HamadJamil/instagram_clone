import 'package:equatable/equatable.dart';
import 'package:instagram/core/models/post_model.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<PostModel> posts;
  final bool hasMore;

  const FeedLoaded({required this.posts, required this.hasMore});

  @override
  List<Object> get props => [posts, hasMore];
}

class FeedLoadingMore extends FeedState {
  final List<PostModel> currentPosts;
  final bool hasMore;

  const FeedLoadingMore({required this.currentPosts, required this.hasMore});

  @override
  List<Object> get props => [currentPosts, hasMore];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object> get props => [message];
}
