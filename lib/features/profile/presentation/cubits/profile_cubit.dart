import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/profile/domain/repositories/profile_repository.dart';
import 'package:instagram/features/profile/presentation/cubits/profile_state.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit({required this.profileRepository}) : super(ProfileInitial());

  Future<void> loadProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final user = await profileRepository.getUserProfile(userId);
      emit(ProfileLoaded(user: user));
      final posts = await profileRepository.getUserPosts(userId);
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(currentState.copyWith(posts: posts));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateProfile(UserModel user) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileLoading());
      try {
        await profileRepository.updateUserProfile(user);
        emit(currentState.copyWith(user: user));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  // Future<void> followUser(String targetUserId) async {
  //   try {
  //     final currentState = state;
  //     if (currentState is ProfileLoaded) {
  //       await profileRepository.followUser(userId, targetUserId);

  //       final updatedUser = currentState.user.copyWith(
  //         following: [...currentState.user.following ?? [], targetUserId],
  //       );

  //       emit(ProfileLoaded(user: updatedUser));
  //     }
  //   } catch (e) {
  //     emit(ProfileError(message: e.toString()));
  //   }
  // }

  // Future<void> unfollowUser(String targetUserId) async {
  //   try {
  //     final currentState = state;
  //     if (currentState is ProfileLoaded) {
  //       await profileRepository.unfollowUser(userId, targetUserId);

  //       final updatedFollowing = currentState.user.following
  //           ?.where((id) => id != targetUserId)
  //           .toList();

  //       final updatedUser = currentState.user.copyWith(
  //         following: updatedFollowing,
  //       );

  //       emit(ProfileLoaded(user: updatedUser));
  //     }
  //   } catch (e) {
  //     emit(ProfileError(message: e.toString()));
  //   }
  // }
}
