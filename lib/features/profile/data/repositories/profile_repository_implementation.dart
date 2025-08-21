import 'package:instagram/features/profile/data/datasources/firebase_user_service.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';
import 'package:instagram/features/profile/data/datasources/firestore_profile_service.dart';
import 'package:instagram/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirestoreProfileService profileService;
  final FirebaseUserService firebaseUserService;

  ProfileRepositoryImpl({
    required this.profileService,
    required this.firebaseUserService,
  });

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final userId = await firebaseUserService.getCurrentUser();
      final userProfile = await profileService.getUserProfile(userId!);
      return userProfile;
    } catch (e) {
      throw Exception('ProfileRepositoryImpl: Failed to get user profile: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) {
    try {
      return profileService.updateUserProfile(user);
    } catch (e) {
      throw Exception(
        'ProfileRepositoryImpl: Failed to update user profile: $e',
      );
    }
  }

  @override
  Future<void> followUser(String userId, String targetUserId) {
    try {
      return profileService.followUser(userId, targetUserId);
    } catch (e) {
      throw Exception('ProfileRepositoryImpl: Failed to follow user: $e');
    }
  }

  @override
  Future<void> unfollowUser(String userId, String targetUserId) {
    try {
      return profileService.unfollowUser(userId, targetUserId);
    } catch (e) {
      throw Exception('ProfileRepositoryImpl: Failed to unfollow user: $e');
    }
  }

  @override
  Future<bool> isFollowing(String userId, String targetUserId) {
    try {
      return profileService.isFollowing(userId, targetUserId);
    } catch (e) {
      throw Exception(
        'ProfileRepositoryImpl: Failed to check follow status: $e',
      );
    }
  }
}
