import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/features/search/presentation/cubits/otheruser/otherUser_state.dart';

class OtherUserProfileCubit extends Cubit<OtherUserProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;

  OtherUserProfileCubit({
    required UserRepository userRepository,
    required PostRepository postRepository,
  }) : _userRepository = userRepository,
       _postRepository = postRepository,
       super(OtherUserProfileInitial());

  Future<void> loadUserProfile(
    String targetUserId,
    String currentUserId,
  ) async {
    emit(OtherUserProfileLoading());

    try {
      final user = await _userRepository.get(targetUserId);
      final posts = await _postRepository.getUserPosts(targetUserId);

      final isFollowing = user.followers?.contains(currentUserId) ?? false;

      emit(
        OtherUserProfileLoaded(
          user: user,
          posts: posts,
          isFollowing: isFollowing,
        ),
      );
    } catch (error) {
      emit(OtherUserProfileError(error.toString()));
    }
  }

  Future<void> followUser(String targetUserId, String currentUserId) async {
    if (state is! OtherUserProfileLoaded) return;

    final currentState = state as OtherUserProfileLoaded;

    try {
      await _userRepository.follow(currentUserId, targetUserId);

      final updatedUser = currentState.user.copyWith(
        followers: [...currentState.user.followers ?? [], currentUserId],
      );

      emit(
        OtherUserProfileLoaded(
          user: updatedUser,
          posts: currentState.posts,
          isFollowing: true,
        ),
      );
    } catch (error) {
      emit(OtherUserProfileError('Failed to follow user: $error'));
      emit(currentState);
    }
  }

  Future<void> unfollowUser(String targetUserId, String currentUserId) async {
    if (state is! OtherUserProfileLoaded) return;

    final currentState = state as OtherUserProfileLoaded;

    try {
      await _userRepository.unfollow(currentUserId, targetUserId);

      final updatedFollowers = List<String>.from(
        currentState.user.followers ?? [],
      )..remove(currentUserId);

      final updatedUser = currentState.user.copyWith(
        followers: updatedFollowers,
      );

      emit(
        OtherUserProfileLoaded(
          user: updatedUser,
          posts: currentState.posts,
          isFollowing: false,
        ),
      );
    } catch (error) {
      emit(OtherUserProfileError('Failed to unfollow user: $error'));
      emit(currentState);
    }
  }

  Future<void> refresh(String targetUserId, String currentUserId) async {
    await loadUserProfile(targetUserId, currentUserId);
  }
}
