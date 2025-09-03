import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<AssetEntity> assets;
  final List<AssetEntity> selectedAssets;
  final bool hasMore;
  final bool isMultiSelection;

  const GalleryLoaded({
    required this.assets,
    required this.selectedAssets,
    required this.hasMore,
    required this.isMultiSelection,
  });

  GalleryLoaded copyWith({
    List<AssetEntity>? assets,
    List<AssetEntity>? selectedAssets,
    bool? hasMore,
    bool? isMultiSelection,
  }) {
    return GalleryLoaded(
      assets: assets ?? this.assets,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      hasMore: hasMore ?? this.hasMore,
      isMultiSelection: isMultiSelection ?? this.isMultiSelection,
    );
  }

  @override
  List<Object> get props => [assets, selectedAssets, hasMore, isMultiSelection];
}

class GalleryLoadingMore extends GalleryState {
  final List<AssetEntity> assets;
  final List<AssetEntity> selectedAssets;
  final bool isMultiSelection;

  const GalleryLoadingMore({
    required this.assets,
    required this.selectedAssets,
    required this.isMultiSelection,
  });

  GalleryLoadingMore copyWith({
    List<AssetEntity>? assets,
    List<AssetEntity>? selectedAssets,
    bool? isMultiSelection,
  }) {
    return GalleryLoadingMore(
      assets: assets ?? this.assets,
      selectedAssets: selectedAssets ?? this.selectedAssets,
      isMultiSelection: isMultiSelection ?? this.isMultiSelection,
    );
  }

  @override
  List<Object> get props => [assets, selectedAssets, isMultiSelection];
}

class GalleryPermissionDenied extends GalleryState {}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError(this.message);

  @override
  List<Object> get props => [message];
}
