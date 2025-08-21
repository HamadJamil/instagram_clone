import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/post/presentation/cubits/post_state.dart';
import 'package:photo_manager/photo_manager.dart';

class PostCubit extends Cubit<PostPageState> {
  PostCubit() : super(PostPageInitial());
  List<AssetEntity> assets = [
    AssetEntity(id: '1', typeInt: 0, height: 10, width: 10),
  ];
  late Future<File?> selectedImageFile;

  void loadPosts() async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      PhotoManager.getAssetListRange(start: 0, end: 100)
          .then((value) {
            assets.addAll(value);
            selectedImageFile = assets[1].file;
            emit(PostPageLoaded(assets, selectedImageFile));
          })
          .catchError((error) {
            emit(PostPageError(error.toString()));
          });
    } else {
      emit(PostPagePermissionRequestDenied());
    }
  }

  void selectImage(AssetEntity asset) {
    try {
      selectedImageFile = asset.file;
      emit(PostPageLoaded(assets, selectedImageFile));
    } catch (error) {
      emit(PostPageError('Failed to load image: ${error.toString()}'));
    }
  }
}
