import 'package:instagram/features/post/domain/entities/post_model.dart';

abstract class FirestorePostRepository {
  //Create post
  Future<void> createPost(PostModel post);
}
