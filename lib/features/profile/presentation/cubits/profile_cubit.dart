import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/profile/domain/repositories/profile_repository.dart';
import 'package:instagram/features/profile/presentation/cubits/profile_state.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit({required this.profileRepository}) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final user = await profileRepository.getUserProfile();
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> updateProfile(UserModel user) async {
    emit(ProfileLoading());
    try {
      await profileRepository.updateUserProfile(user);
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
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
