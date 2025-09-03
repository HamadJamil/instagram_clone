import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/core/models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  Future<void> create(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      throw Exception(
        'Unable to create your account. Please check your connection and try again.',
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
      throw Exception('Could not update your profile. Please try again.');
    }
  }

  Future<UserModel> get(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        throw Exception(
          'User profile not found. The account may have been deleted.',
        );
      }
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception(
        'Unable to load profile information. Please check your connection.',
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
      throw Exception(
        'Search failed. Please check your connection and try again.',
      );
    }
  }

  Future<void> postCount(String userId, int incrementBy) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.set({
        'postCount': FieldValue.increment(incrementBy),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(
        'Could not update your post count. This won\'t affect your post.',
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
      throw Exception('Unable to follow this user. Please try again.');
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
      throw Exception('Unable to unfollow this user. Please try again.');
    }
  }
}
