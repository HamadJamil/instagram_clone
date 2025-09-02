import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/utils/exceptions.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> create(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } on Exception catch (e) {
      throw FirestoreException(
        'FirestoreUserService: Failed to create user: ${e.toString()}',
      );
    }
  }

  Future<void> update(UserModel user) async {
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

  Future<UserModel> get(String userId) async {
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

  Future<List<UserModel>> search(String query, String userId) async {
    try {
      final snapshot = await _firestore.collection('users').limit(100).get();
      final user = snapshot.docs
          .where((doc) {
            final data = doc.data();
            return data['name'].toString().toLowerCase().contains(
                  query.toLowerCase(),
                ) &&
                userId != doc.id;
          })
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
      return user;
    } catch (e) {
      throw Exception('FirestoreSearchService: Failed to search users: $e');
    }
  }

  Future<void> incrementPostCount(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.set({
        'postCount': FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(
        'FirestoreProfileService :Failed to increment post count: $e',
      );
    }
  }

  Future<void> decrementPostCount(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.set({
        'postCount': FieldValue.increment(-1),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(
        'FirestoreProfileService :Failed to decrement post count: $e',
      );
    }
  }

  Future<void> follow(String userId, String targetUserId) async {
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

  Future<void> unfollow(String userId, String targetUserId) async {
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
}
