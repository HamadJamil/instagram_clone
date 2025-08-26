import 'package:instagram/features/feed/data/datasources/firestore_feed_service.dart';
import 'package:instagram/features/feed/domain/repositories/feed_repository.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';

class FeedRepositoryImplementation implements FeedRepository {
  final FirestoreFeedService _firestoreFeedService;

  FeedRepositoryImplementation(this._firestoreFeedService);

  @override
  Future<List<PostModel>> fetchPosts(String userId) async {
    final snapshot = await _firestoreFeedService.fetchPosts(userId);
    return snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList();
  }
}
