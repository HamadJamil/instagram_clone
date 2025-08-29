import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/core/repository/strorage_repository.dart';
import 'package:instagram/core/repository/user_repository.dart';
import 'package:instagram/core/utils/utils.dart';
import 'package:instagram/features/post/presentation/cubits/post_state.dart';
import 'package:photo_manager/photo_manager.dart';

class PostCubit extends Cubit<PostPageState> {
  final UserRepository _userRepository;
  final PostRepository postRepository;
  final StorageRepository storageRepository;
  PostCubit(this.postRepository, this.storageRepository, this._userRepository)
    : super(PostPageInitial());

  void createPost(PostModel post, List<File> images) async {
    emit(PostPageLoading());
    try {
      final imageUrls = await storageRepository.postImages(images);
      await postRepository.create(post.copyWith(imageUrls: imageUrls));
      emit(PostPagePostCreated());
      _userRepository.incrementPostCount(post.authorId);
    } catch (error) {
      emit(PostPageError(error.toString()));
    }
  }

  void loadPosts(String userId) async {
    try {
      final result = await checkAndRequestGalleryPermission();
      if (!result) {
        emit(PostPagePermissionRequestDenied());
        return;
      }
      final List<AssetEntity> loadedAssets =
          await PhotoManager.getAssetListRange(start: 0, end: 100);
      final initialSelectedAssets = loadedAssets.isNotEmpty
          ? [loadedAssets[0]]
          : [];
      final UserModel user = await _userRepository.get(userId);
      emit(
        PostPageLoaded(
          memoryImages: loadedAssets,
          selectedImages: initialSelectedAssets as List<AssetEntity>,
          user: user,
        ),
      );
    } catch (error) {
      emit(PostPageError(error.toString()));
    }
  }

  void selectImage(AssetEntity asset) {
    if (state is! PostPageLoaded) return;

    final currentState = state as PostPageLoaded;

    if (currentState.selectedImages.contains(asset)) return;

    emit(
      currentState.copyWith(selectedImages: [asset], isSelectionChanged: true),
    );
  }

  void addToSelection(AssetEntity asset) {
    if (state is! PostPageLoaded) return;

    final currentState = state as PostPageLoaded;
    final newSelection = List<AssetEntity>.from(currentState.selectedImages);

    if (newSelection.contains(asset)) {
      newSelection.remove(asset);
    } else {
      newSelection.add(asset);
    }

    emit(
      currentState.copyWith(
        selectedImages: newSelection,
        isSelectionChanged: true,
      ),
    );
  }
}
