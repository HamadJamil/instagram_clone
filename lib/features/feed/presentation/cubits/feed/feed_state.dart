import 'package:equatable/equatable.dart';
import 'package:instagram/core/models/post_model.dart';

abstract class FeedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<PostModel> posts;
  final bool hasMore;

  FeedLoaded(this.posts, {this.hasMore = true});

  @override
  List<Object?> get props => [posts, hasMore];
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);

  @override
  List<Object?> get props => [message];
}

class FeedLoadingMore extends FeedState {
  final List<PostModel> currentPosts;
  FeedLoadingMore(this.currentPosts);

  @override
  List<Object?> get props => [currentPosts];
}

class FeedRefreshing extends FeedState {
  final List<PostModel> currentPosts;
  FeedRefreshing(this.currentPosts);

  @override
  List<Object?> get props => [currentPosts];
}
