import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/post/presentation/cubits/gallery/gallery_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/gallery/gallery_state.dart';
import 'package:instagram/features/post/presentation/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.userId});
  final String userId;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<GalleryCubit>().loadGalleryImages();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<GalleryCubit>().loadMoreImages();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('New Post'),
        actions: [
          BlocSelector<GalleryCubit, GalleryState, List<AssetEntity>>(
            selector: (state) {
              if (state is GalleryLoaded) return state.selectedAssets;
              if (state is GalleryLoadingMore) return state.selectedAssets;
              return [];
            },
            builder: (context, selectedAssets) {
              return TextButton(
                onPressed: selectedAssets.isNotEmpty
                    ? () => context.pushNamed(
                        AppRouteName.postCaptionPage,
                        extra: {
                          'selectedImages': selectedAssets,
                          'userId': widget.userId,
                        },
                      )
                    : null,
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<GalleryCubit, GalleryState>(
        listener: (context, state) {
          if (state is GalleryError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is GalleryPermissionDenied) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gallery permission denied')),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is GalleryInitial || state is GalleryLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is GalleryLoaded || state is GalleryLoadingMore) {
            // Extract data with proper type checking
            final assets = state is GalleryLoaded
                ? state.assets
                : (state as GalleryLoadingMore).assets;
            final selectedAssets = state is GalleryLoaded
                ? state.selectedAssets
                : (state as GalleryLoadingMore).selectedAssets;
            final hasMore = state is GalleryLoaded ? state.hasMore : false;
            final isMultiSelection = state is GalleryLoaded
                ? state.isMultiSelection
                : (state as GalleryLoadingMore).isMultiSelection;
            final isLoadingMore = state is GalleryLoadingMore;

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Selected image preview
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.5,
                    child: _buildSelectedPictures(selectedAssets),
                  ),
                ),

                // Header with multi-selection toggle
                SliverAppBar(
                  titleSpacing: 5,
                  title: Row(
                    children: [
                      const Text('Recent'),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          isMultiSelection
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: isMultiSelection
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                        onPressed: () {
                          if (isMultiSelection) {
                            // Turn off multi-selection and clear extra selections
                            context
                                .read<GalleryCubit>()
                                .clearSelectionsExceptFirst();
                          } else {
                            // Turn on multi-selection
                            context.read<GalleryCubit>().toggleMultiSelection();
                          }
                        },
                      ),
                    ],
                  ),
                  automaticallyImplyLeading: false,
                  floating: false,
                  pinned: true,
                ),

                // Gallery grid
                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: assets.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == assets.length) {
                      return Center(
                        child: isLoadingMore
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () => context
                                    .read<GalleryCubit>()
                                    .loadMoreImages(),
                                child: Text('Load More'),
                              ),
                      );
                    }

                    final asset = assets[index];
                    final isSelected = selectedAssets.contains(asset);

                    return InkWell(
                      onTap: () {
                        context.read<GalleryCubit>().toggleAssetSelection(
                          asset,
                        );
                      },
                      child: Stack(
                        children: [
                          AssetThumbnail(asset: asset),
                          if (isSelected)
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: isMultiSelection ? 24 : 32,
                                ),
                              ),
                            ),
                          if (isMultiSelection && isSelected)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${selectedAssets.indexOf(asset) + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }

          if (state is GalleryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error loading gallery'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<GalleryCubit>().loadGalleryImages(),
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSelectedPictures(List<AssetEntity> selectedAssets) {
    if (selectedAssets.isEmpty) {
      return const Center(child: Icon(Icons.image, size: 64));
    }

    return PageView.builder(
      itemCount: selectedAssets.length,
      itemBuilder: (context, index) {
        final asset = selectedAssets[index];
        return FutureBuilder<File?>(
          future: asset.file,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final file = snapshot.data;
            if (file == null) {
              return Center(child: Icon(Icons.error));
            }

            return Image.file(file, fit: BoxFit.cover);
          },
        );
      },
    );
  }
}
