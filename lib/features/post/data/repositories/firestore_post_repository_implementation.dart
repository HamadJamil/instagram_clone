import 'package:instagram/features/post/data/datasources/firestore_post_service.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';
import 'package:instagram/features/post/domain/repositories/firestore_post_repository.dart';

class FirestorePostRepositoryImplementation implements FirestorePostRepository {
  final FirestorePostService _firestorePostService;

  FirestorePostRepositoryImplementation(this._firestorePostService);

  @override
  Future<void> createPost(PostModel post) async {
    await _firestorePostService.createPost(post);
  }
}
