import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/core/repository/strorage_repository.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/features/profile/presentation/cubits/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;

  ProfileCubit(
    this._userRepository,
    this._postRepository,
    this._storageRepository,
  ) : super(ProfileInitial());

  Future<void> load(String userId) async {
    emit(ProfileLoading());
    try {
      final user = await _userRepository.get(userId);
      emit(ProfileLoaded(user: user));
      final posts = await _postRepository.getUserPosts(userId);
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(currentState.copyWith(posts: posts));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> update({UserModel? user, File? profilePhoto}) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileLoading());

      try {
        UserModel updatedUser = user ?? currentState.user;

        if (profilePhoto != null) {
          final imageUrl = await _storageRepository.uploadProfilePhoto(
            profilePhoto,
          );
          updatedUser = updatedUser.copyWith(photoUrl: imageUrl);
        }

        await _userRepository.update(updatedUser);

        emit(currentState.copyWith(user: updatedUser));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
        emit(currentState);
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
