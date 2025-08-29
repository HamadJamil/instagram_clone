import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/features/feed/presentation/cubits/feed/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final PostRepository _postRepository;

  FeedCubit(this._postRepository) : super(FeedInitial());

  Future<void> fetchPosts(String userId) async {
    emit(FeedLoading());
    try {
      _postRepository.resetPagination();
      final posts = await _postRepository.fetch(userId);
      emit(FeedLoaded(posts, hasMore: _postRepository.hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> loadMorePosts(String userId) async {
    if (state is! FeedLoaded || !_postRepository.hasMore) return;

    final currentState = state as FeedLoaded;
    emit(FeedLoadingMore(currentState.posts));

    try {
      final newPosts = await _postRepository.fetch(userId, loadMore: true);
      emit(FeedLoaded(newPosts, hasMore: _postRepository.hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> refreshPosts(String userId) async {
    if (state is FeedLoaded) {
      final currentState = state as FeedLoaded;
      emit(FeedRefreshing(currentState.posts));
    } else {
      emit(FeedLoading());
    }

    try {
      final posts = await _postRepository.fetch(userId, refresh: true);
      emit(FeedLoaded(posts, hasMore: _postRepository.hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }
}
