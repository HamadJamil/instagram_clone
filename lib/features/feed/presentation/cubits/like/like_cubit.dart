import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/features/feed/presentation/cubits/like/like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  final String postId;
  final String userId;
  final PostRepository _postRepository;

  LikeCubit({
    required this.postId,
    required this.userId,
    required PostRepository postRepository,
  }) : _postRepository = postRepository,
       super(LikeInitial()) {
    _startListening();
  }

  void _startListening() {
    _postRepository.postStream(postId).listen((snapshot) {
      if (snapshot.exists) {
        final post = PostModel.fromJson(
          snapshot.data() as Map<String, dynamic>,
        );
        final isLiked = post.isLikedBy(userId);
        final likesCount = post.likesCount;

        emit(LikeLoaded(isLiked: isLiked, likesCount: likesCount));
      }
    });
  }

  Future<void> toggleLike() async {
    final currentState = state;
    if (currentState is LikeLoaded) {
      try {
        if (currentState.isLiked) {
          await _postRepository.unlikePost(postId, userId);
        } else {
          await _postRepository.likePost(postId, userId);
        }
      } catch (e) {
        emit(LikeError('Failed to toggle like: $e'));
        Future.delayed(const Duration(seconds: 2), () {
          if (state is LikeError) {
            emit(currentState);
          }
        });
      }
    }
  }

  Future<void> close() {
    return super.close();
  }
}
