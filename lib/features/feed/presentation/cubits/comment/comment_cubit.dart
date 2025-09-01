import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/comment_model.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/repository/comment_repository.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/features/feed/presentation/cubits/comment/comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository _commentRepository;
  final UserRepository _userRepository;
  final String postId;
  final String currentUserId;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  StreamSubscription<List<Comment>>? _commentsSubscription;
  UserModel? _currentUser;

  CommentCubit({
    required CommentRepository commentRepository,
    required UserRepository userRepository,
    required this.postId,
    required this.currentUserId,
  }) : _commentRepository = commentRepository,
       _userRepository = userRepository,
       super(CommentInitial()) {
    _loadCurrentUserAndComments();
  }

  Future<void> _loadCurrentUserAndComments() async {
    emit(CommentLoading());

    try {
      _currentUser = await _userRepository.get(currentUserId);
      _lastDocument = await _commentRepository.getLastDocument(postId: postId);
      _commentsSubscription = _commentRepository
          .getCommentsStream(postId: postId)
          .listen(
            (comments) {
              _hasMore = comments.length >= 15;
              emit(CommentLoaded(comments: comments, hasMore: _hasMore));
            },
            onError: (error) {
              emit(CommentError(error.toString()));
            },
          );
    } catch (error) {
      emit(CommentError('Failed to load comments: $error'));
    }
  }

  Future<void> addComment(String text) async {
    if (state is CommentLoaded && _currentUser != null) {
      final currentState = state as CommentLoaded;
      emit(CommentAdding(currentState.comments, currentState.hasMore));

      try {
        final comment = Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorId: currentUserId,
          authorName: _currentUser!.name,
          authorAvatar: _currentUser!.photoUrl,
          text: text,
          createdAt: DateTime.now(),
        );

        await _commentRepository.addComment(postId: postId, comment: comment);
      } catch (error) {
        emit(CommentError('Failed to add comment: $error'));
        emit(currentState);
      }
    }
  }

  Future<void> loadMoreComments() async {
    if (!_hasMore || state is CommentLoadingMore || _lastDocument == null) {
      return;
    }

    final currentState = state;
    if (currentState is CommentLoaded) {
      emit(
        CommentLoadingMore(
          currentComments: currentState.comments,
          hasMore: currentState.hasMore,
        ),
      );

      try {
        final newComments = await _commentRepository.loadMoreComments(
          postId: postId,
          lastDocument: _lastDocument!,
        );

        if (newComments.isEmpty) {
          _hasMore = false;
          emit(CommentLoaded(comments: currentState.comments, hasMore: false));
          return;
        }

        _lastDocument = await _commentRepository.getLastDocument(
          postId: postId,
          limit: currentState.comments.length + newComments.length,
        );

        final allComments = [...currentState.comments, ...newComments];
        emit(
          CommentLoaded(
            comments: allComments,
            hasMore: newComments.length == 10,
          ),
        );
      } catch (error) {
        emit(CommentError('Failed to load more comments: $error'));
        emit(currentState);
      }
    }
  }

  Future<void> refreshComments() async {
    emit(CommentLoading());
    await _commentsSubscription?.cancel();
    _lastDocument = null;
    _hasMore = true;
    _loadCurrentUserAndComments();
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }
}
