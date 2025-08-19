import 'package:instagram/features/auth/data/datasources/firestore_user_service.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';
import 'package:instagram/features/auth/domain/repositories/user_repository.dart';

class UserRepositoryImplementation implements UserRepository {
  final FireStoreUserService _fireStoreUser;

  const UserRepositoryImplementation(this._fireStoreUser);

  @override
  Future<UserModel?> getUser(String userId) {
    return _fireStoreUser.getUser(userId);
  }

  @override
  Stream<UserModel?> userStream(String userId) {
    return _fireStoreUser.userStream(userId);
  }

  @override
  Future<void> updateUser(UserModel user) {
    return _fireStoreUser.updateUser(user);
  }

  @override
  Future<void> deleteUser(String userId) {
    return _fireStoreUser.deleteUser(userId);
  }
}
