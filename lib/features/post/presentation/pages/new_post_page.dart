import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/core/utils/toast.dart';
import 'package:instagram/core/utils/utils.dart';
import 'package:instagram/features/post/presentation/cubits/gallery/gallery_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/gallery/gallery_state.dart';
import 'package:instagram/features/post/presentation/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key, required this.userId});
  final String userId;

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  void initState() {
    super.initState();
    context.read<GalleryCubit>().loadGalleryImages();
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
                    ? () async {
                        final imageFiles =
                            await convertAssetEntityListToFileList(
                              selectedAssets,
                            );
                        context.pushNamed(
                          AppRouteName.postCaptionPage,
                          extra: {
                            'selectedImages': imageFiles,
                            'userId': widget.userId,
                          },
                        );
                      }
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
            ToastUtils.showErrorToast(context, state.message);
          }
          if (state is GalleryPermissionDenied) {
            ToastUtils.showErrorToast(context, 'Gallery permission denied');
          }
        },
        builder: (context, state) {
          if (state is GalleryInitial || state is GalleryLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is GalleryLoaded || state is GalleryLoadingMore) {
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
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.5,
                    child: _buildSelectedPictures(selectedAssets),
                  ),
                ),

                SliverAppBar(
                  titleSpacing: 5,
                  title: Row(
                    children: [
                      const Text('Recent'),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          isMultiSelection
                              ? Icons.copy_outlined
                              : Icons.copy_outlined,
                          color: isMultiSelection
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                        onPressed: () {
                          context.read<GalleryCubit>().toggleMultiSelection();
                        },
                      ),
                    ],
                  ),
                  automaticallyImplyLeading: false,
                  floating: false,
                  pinned: true,
                ),

                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    final isSelected = selectedAssets.contains(asset);

                    return InkWell(
                      onTap: () {
                        context.read<GalleryCubit>().toggleAssetSelection(
                          asset,
                        );
                      },
                      child: Stack(
                        fit: StackFit.expand,
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

                SliverToBoxAdapter(
                  child: hasMore
                      ? Center(
                          child: isLoadingMore
                              ? CircularProgressIndicator()
                              : TextButton(
                                  onPressed: () => context
                                      .read<GalleryCubit>()
                                      .loadMoreImages(),
                                  child: Text('See More'),
                                ),
                        )
                      : SizedBox.shrink(),
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

    return PageView(
      children: [
        FutureBuilder<File?>(
          future: selectedAssets.last.file,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final file = snapshot.data;
            if (file == null) {
              return Center(child: Icon(Icons.error));
            }

            return Image.file(file, fit: BoxFit.fitHeight);
          },
        ),
      ],
    );
  }
}
