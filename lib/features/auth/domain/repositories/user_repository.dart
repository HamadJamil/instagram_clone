import 'package:instagram/features/auth/domain/entities/user_model.dart';

abstract class UserRepository {
  //Get User
  Future<UserModel?> getUser(String userId);
  //User Stream
  Stream<UserModel?> userStream(String userId);
  //Update User
  Future<void> updateUser(UserModel user);
  //Delete User
  Future<void> deleteUser(String userId);
}
