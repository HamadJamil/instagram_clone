import 'package:instagram/features/auth/domain/entities/user_model.dart';
import 'package:instagram/features/search/data/datasources/firestore_search_service.dart';
import 'package:instagram/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImplementation implements SearchRepository {
  final FirestoreSearchService _firestoreSearchService;

  SearchRepositoryImplementation(this._firestoreSearchService);

  @override
  Future<List<UserModel>> searchUsers(String query, String userId) async {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();

    final userSnapshot = await _firestoreSearchService.searchUsers();

    return userSnapshot.docs
        .where((doc) {
          final user = UserModel.fromJson(doc.data());
          return user.name.toLowerCase().contains(lowerQuery) &&
              user.uid != userId;
        })
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }
}
