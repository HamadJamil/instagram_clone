import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/utils/utils.dart';
import 'package:instagram/features/post/presentation/cubits/gallery/gallery_state.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryCubit extends Cubit<GalleryState> {
  final int _pageSize = 30;
  int _currentPage = 0;
  bool _hasMore = true;
  final List<AssetEntity> _allAssets = [];
  List<AssetEntity> _selectedAssets = [];
  bool _isMultiSelection = false;

  GalleryCubit() : super(GalleryInitial());

  Future<void> loadGalleryImages() async {
    emit(GalleryLoading());

    try {
      final hasPermission = await checkAndRequestGalleryPermission();
      if (!hasPermission) {
        emit(GalleryPermissionDenied());
        return;
      }

      await _loadNextPage();
    } catch (error) {
      emit(GalleryError(error.toString()));
    }
  }

  Future<void> loadMoreImages() async {
    if (!_hasMore || state is GalleryLoadingMore) return;

    final currentState = state;
    if (currentState is GalleryLoaded) {
      emit(
        GalleryLoadingMore(
          assets: _allAssets,
          selectedAssets: _selectedAssets,
          isMultiSelection: _isMultiSelection,
        ),
      );

      try {
        await _loadNextPage();
      } catch (error) {
        emit(GalleryError(error.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> _loadNextPage() async {
    final List<AssetEntity> loadedAssets = await PhotoManager.getAssetListPaged(
      page: _currentPage,
      pageCount: _pageSize,
      type: RequestType.image,
    );

    if (loadedAssets.isEmpty) {
      _hasMore = false;
    } else {
      _allAssets.addAll(loadedAssets);
      _currentPage++;
    }

    final initialSelection = _allAssets.isNotEmpty ? [_allAssets[0]] : [];
    if (_selectedAssets.isEmpty && initialSelection.isNotEmpty) {
      _selectedAssets = initialSelection as List<AssetEntity>;
    }

    emit(
      GalleryLoaded(
        assets: _allAssets,
        selectedAssets: _selectedAssets,
        hasMore: _hasMore,
        isMultiSelection: _isMultiSelection,
      ),
    );
  }

  void toggleMultiSelection() {
    if (state is! GalleryLoaded) return;

    _isMultiSelection = !_isMultiSelection;

    if (state is GalleryLoaded) {
      final currentState = state as GalleryLoaded;
      emit(currentState.copyWith(isMultiSelection: _isMultiSelection));
    }
  }

  void toggleAssetSelection(AssetEntity asset) {
    if (state is! GalleryLoaded) return;

    final newSelection = List<AssetEntity>.from(_selectedAssets);

    if (newSelection.contains(asset)) {
      newSelection.remove(asset);
    } else {
      if (!_isMultiSelection) {
        newSelection.clear();
      }
      newSelection.add(asset);
    }

    if (!_listEquals(newSelection, _selectedAssets)) {
      _selectedAssets = newSelection;

      if (state is GalleryLoaded) {
        final currentState = state as GalleryLoaded;
        emit(currentState.copyWith(selectedAssets: _selectedAssets));
      }
    }
  }

  bool _listEquals(List<AssetEntity> list1, List<AssetEntity> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  void clearSelectionsExceptFirst() {
    List<AssetEntity> newSelection;
    if (_selectedAssets.isNotEmpty) {
      newSelection = [_selectedAssets.first];
    } else if (_allAssets.isNotEmpty) {
      newSelection = [_allAssets.first];
    } else {
      newSelection = [];
    }

    if (!_listEquals(newSelection, _selectedAssets)) {
      _selectedAssets = newSelection;
      _isMultiSelection = false;

      if (state is GalleryLoaded) {
        final currentState = state as GalleryLoaded;
        emit(
          currentState.copyWith(
            selectedAssets: _selectedAssets,
            isMultiSelection: _isMultiSelection,
          ),
        );
      }
    }
  }

  List<AssetEntity> get selectedAssets => _selectedAssets;

  void reset() {
    _currentPage = 0;
    _hasMore = true;
    _allAssets.clear();
    _selectedAssets.clear();
    emit(GalleryInitial());
  }
}
