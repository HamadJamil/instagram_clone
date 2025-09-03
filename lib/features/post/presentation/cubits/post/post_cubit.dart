import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/repository/comment_repository.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/core/repository/strorage_repository.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/features/post/presentation/cubits/post/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;
  final StorageRepository storageRepository;
  final UserRepository userRepository;
  final CommentRepository commentRepository;

  PostCubit(
    this.postRepository,
    this.storageRepository,
    this.userRepository,
    this.commentRepository,
  ) : super(PostInitial());

  Future<void> createPost(
    String userId,
    String caption,
    List<File> images,
  ) async {
    emit(PostLoading());
    try {
      final imageUrls = await storageRepository.postImages(images);
      final user = await userRepository.get(userId);
      await postRepository.create(
        PostModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          authorId: userId,
          authorName: user.name,
          authorImage: user.photoUrl,
          imageUrls: imageUrls,
          caption: caption,
          createdAt: DateTime.now(),
        ),
      );
      emit(PostCreated());
      userRepository.postCount(userId, 1);
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  Future<void> deletePost(
    String postId,
    String userId,
    List<String> imageUrls,
  ) async {
    emit(PostLoading());
    try {
      await postRepository.delete(postId);
      emit(PostDeleted());
      await Future.wait([
        userRepository.postCount(userId, -1),
        storageRepository.deleteImages(imageUrls),
        commentRepository.deleteComments(postId),
      ]);
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }

  Future<void> updatePost(PostModel post) async {
    emit(PostLoading());
    try {
      await postRepository.update(post);
      emit(PostUpdated());
    } catch (error) {
      emit(PostError(error.toString()));
    }
  }
}
