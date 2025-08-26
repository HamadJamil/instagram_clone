import 'package:instagram/features/auth/domain/entities/user_model.dart';

abstract class SearchRepository {
  /// Searches for users
  Future<List<UserModel>> searchUsers(String query, String userId);
}
