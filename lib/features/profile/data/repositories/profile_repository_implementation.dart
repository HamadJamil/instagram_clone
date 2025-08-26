import 'package:instagram/features/post/domain/entities/post_model.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';
import 'package:instagram/features/profile/data/datasources/firestore_profile_service.dart';
import 'package:instagram/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirestoreProfileService profileService;

  ProfileRepositoryImpl({required this.profileService});

  @override
  Future<UserModel> getUserProfile(String userId) async {
    final userProfile = await profileService.getUserProfile(userId);
    return userProfile;
  }

  @override
  Future<void> updateUserProfile(UserModel user) {
    return profileService.updateUserProfile(user);
  }

  @override
  Future<void> followUser(String userId, String targetUserId) {
    return profileService.followUser(userId, targetUserId);
  }

  @override
  Future<void> unfollowUser(String userId, String targetUserId) {
    return profileService.unfollowUser(userId, targetUserId);
  }

  @override
  Future<bool> isFollowing(String userId, String targetUserId) {
    return profileService.isFollowing(userId, targetUserId);
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    return profileService.getUserPosts(userId);
  }
}
