import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/features/feed/presentation/cubits/feed/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  final PostRepository _postRepository;
  final String _userId;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  StreamSubscription<List<PostModel>>? _postsSubscription;

  FeedCubit(this._postRepository, this._userId) : super(FeedInitial());

  void subscribeToFeed() {
    emit(FeedLoading());

    try {
      _lastDocument = null;
      _hasMore = true;

      _postsSubscription = _postRepository.getPostsStream().listen(
        (posts) async {
          if (posts.isNotEmpty) {
            _lastDocument = await _postRepository.getLastDocument();
            _hasMore = posts.length >= 10;

            emit(FeedLoaded(posts: posts, hasMore: _hasMore));
          } else {
            emit(FeedLoaded(posts: [], hasMore: false));
          }
        },
        onError: (error) {
          emit(FeedError(error.toString()));
        },
      );
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> loadMorePosts() async {
    if (!_hasMore || state is FeedLoadingMore || _lastDocument == null) return;

    final currentState = state;
    if (currentState is FeedLoaded) {
      emit(
        FeedLoadingMore(
          currentPosts: currentState.posts,
          hasMore: currentState.hasMore,
        ),
      );

      try {
        final newPosts = await _postRepository.loadMorePosts(
          lastDocument: _lastDocument!,
        );

        if (newPosts.isEmpty) {
          _hasMore = false;
          emit(FeedLoaded(posts: currentState.posts, hasMore: false));
          return;
        }

        _lastDocument = await _postRepository.getLastDocument(
          limit: currentState.posts.length + newPosts.length,
        );

        final allPosts = [...currentState.posts, ...newPosts];
        emit(FeedLoaded(posts: allPosts, hasMore: newPosts.length == 10));
      } catch (e) {
        emit(FeedError(e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> toggleLike(String postId) async {
    final currentState = state;
    if (currentState is FeedLoaded) {
      try {
        final postIndex = currentState.posts.indexWhere(
          (post) => post.id == postId,
        );
        if (postIndex != -1) {
          final post = currentState.posts[postIndex];
          final isLiked = post.isLikedBy(_userId);

          if (isLiked) {
            await _postRepository.unlikePost(postId, _userId);
          } else {
            await _postRepository.likePost(postId, _userId);
          }
        }
      } catch (e) {
        emit(FeedError('Failed to toggle like: $e'));
        emit(currentState);
      }
    }
  }

  Future<void> refreshFeed() async {
    await _postsSubscription?.cancel();
    _lastDocument = null;
    _hasMore = true;

    subscribeToFeed();
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
