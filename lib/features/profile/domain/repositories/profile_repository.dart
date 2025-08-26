import 'package:instagram/features/auth/domain/entities/user_model.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';

abstract class ProfileRepository {
  //Get User Posts
  Future<List<PostModel>> getUserPosts(String userId);
  //Get User Profile
  Future<UserModel> getUserProfile(String userId);
  //Update User Profile
  Future<void> updateUserProfile(UserModel user);
  //Follow User
  Future<void> followUser(String userId, String targetUserId);
  //Unfollow User
  Future<void> unfollowUser(String userId, String targetUserId);
  //Check Following
  Future<bool> isFollowing(String userId, String targetUserId);
}
