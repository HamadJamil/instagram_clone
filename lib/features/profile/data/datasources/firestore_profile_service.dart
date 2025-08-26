import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';

class FirestoreProfileService {
  final FirebaseFirestore _firestore;

  FirestoreProfileService(this._firestore);

  Future<UserModel> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception(' FirestoreProfileService :User document not found');
      }
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception(
        'FirestoreProfileService :Failed to get user profile: $e',
      );
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': user.name,
        'bio': user.bio,
        'photoUrl': user.photoUrl,
      });
    } catch (e) {
      throw Exception('FirestoreProfileService :Failed to update profile: $e');
    }
  }

  Future<List<PostModel>> getUserPosts(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('FirestoreProfileService :Failed to get user posts: $e');
    }
  }

  Future<void> followUser(String userId, String targetUserId) async {
    try {
      final batch = _firestore.batch();
      final currentUserRef = _firestore.collection('users').doc(userId);
      batch.update(currentUserRef, {
        'following': FieldValue.arrayUnion([targetUserId]),
      });
      final targetUserRef = _firestore.collection('users').doc(targetUserId);
      batch.update(targetUserRef, {
        'followers': FieldValue.arrayUnion([userId]),
      });
      await batch.commit();
    } catch (e) {
      throw Exception('FirestoreProfileService :Failed to follow user: $e');
    }
  }

  Future<void> unfollowUser(String userId, String targetUserId) async {
    try {
      final batch = _firestore.batch();
      final currentUserRef = _firestore.collection('users').doc(userId);
      batch.update(currentUserRef, {
        'following': FieldValue.arrayRemove([targetUserId]),
      });
      final targetUserRef = _firestore.collection('users').doc(targetUserId);
      batch.update(targetUserRef, {
        'followers': FieldValue.arrayRemove([userId]),
      });
      await batch.commit();
    } catch (e) {
      throw Exception('FirestoreProfileService :Failed to unfollow user: $e');
    }
  }

  Future<bool> isFollowing(String userId, String targetUserId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final following = List<String>.from(doc.data()?['following'] ?? []);
      return following.contains(targetUserId);
    } catch (e) {
      throw Exception(
        'FirestoreProfileService :Failed to check follow status: $e',
      );
    }
  }
}
