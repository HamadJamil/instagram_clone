import 'package:equatable/equatable.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class PostPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostPageInitial extends PostPageState {}

class PostPageLoading extends PostPageState {}

class PostPagePostCreated extends PostPageState {}

class PostPageLoaded extends PostPageState {
  final List<AssetEntity> memoryImages;
  final List<AssetEntity> selectedImages;
  final UserModel user;
  final bool isSelectionChanged;

  PostPageLoaded({
    required this.memoryImages,
    required this.selectedImages,
    required this.user,
    this.isSelectionChanged = false,
  });

  PostPageLoaded copyWith({
    UserModel? user,
    List<AssetEntity>? memoryImages,
    List<AssetEntity>? selectedImages,
    bool? isSelectionChanged,
  }) {
    return PostPageLoaded(
      user: user ?? this.user,
      memoryImages: memoryImages ?? this.memoryImages,
      selectedImages: selectedImages ?? this.selectedImages,
      isSelectionChanged: isSelectionChanged ?? this.isSelectionChanged,
    );
  }

  @override
  List<Object?> get props => [
    memoryImages,
    selectedImages,
    isSelectionChanged,
    user,
  ];
}

class PostPagePermissionRequestDenied extends PostPageState {}

class PostPageError extends PostPageState {
  final String message;

  PostPageError(this.message);
}
