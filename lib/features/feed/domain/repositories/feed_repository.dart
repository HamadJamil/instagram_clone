import 'package:instagram/features/post/domain/entities/post_model.dart';

abstract class FeedRepository {
  //Fetch posts
  Future<List<PostModel>> fetchPosts(String userId);
}
