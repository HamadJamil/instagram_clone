import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';
import 'package:instagram/features/post/domain/repositories/firestore_post_repository.dart';
import 'package:instagram/features/post/presentation/cubits/post_state.dart';
import 'package:photo_manager/photo_manager.dart';

class PostCubit extends Cubit<PostPageState> {
  final FirestorePostRepository postRepository;
  PostCubit({required this.postRepository}) : super(PostPageInitial());

  void createPost(PostModel post) async {
    emit(PostPageLoading());
    try {
      await postRepository.createPost(post);
      emit(PostPagePostCreated());
    } catch (error) {
      emit(PostPageError(error.toString()));
    }
  }

  void loadPosts() async {
    try {
      final PermissionState result =
          await PhotoManager.requestPermissionExtend();
      if (!result.isAuth) {
        emit(PostPagePermissionRequestDenied());
        return;
      }
      final List<AssetEntity> loadedAssets =
          await PhotoManager.getAssetListRange(start: 0, end: 100);
      final initialSelectedAssets = loadedAssets.isNotEmpty
          ? [loadedAssets[0]]
          : [];
      emit(
        PostPageLoaded(
          memoryImages: loadedAssets,
          selectedImages: initialSelectedAssets as List<AssetEntity>,
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
