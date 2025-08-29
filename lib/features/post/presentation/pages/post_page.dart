import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/post/presentation/cubits/post_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/post_state.dart';
import 'package:instagram/features/post/presentation/widgets/asset_thumbnail.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.userId});
  final String userId;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    context.read<PostCubit>().loadPosts(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: const Text('New Post'),
        actions: [
          BlocBuilder<PostCubit, PostPageState>(
            buildWhen: (previous, current) {
              return current is PostPageLoaded && current.isSelectionChanged;
            },
            builder: (context, state) {
              return TextButton(
                onPressed:
                    state is PostPageLoaded && state.selectedImages.isNotEmpty
                    ? () => context.pushNamed(
                        AppRouteName.postCaptionPage,
                        extra: {
                          'selectedImages': state.selectedImages,
                          'user': state.user,
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
      body: BlocConsumer<PostCubit, PostPageState>(
        listener: (context, state) {
          if (state is PostPageError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is PostPagePermissionRequestDenied) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Permission denied')));
            Navigator.of(context).pop();
          }
        },
        buildWhen: (previous, current) {
          if (current is PostPageLoaded && previous is PostPageLoaded) {
            return !current.isSelectionChanged;
          }
          return true;
        },
        builder: (context, state) {
          if (state is PostPageLoading) {
            return Center(
              child: SpinKitChasingDots(color: AppColors.primary, size: 40),
            );
          }

          if (state is PostPageLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.5,
                    child: _buildSelectedPictures(state.selectedImages),
                  ),
                ),

                SliverAppBar(
                  titleSpacing: 5,
                  title: const Text('Recent'),
                  automaticallyImplyLeading: false,
                  floating: false,
                ),

                SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemCount: state.memoryImages.length,
                  itemBuilder: (context, index) {
                    final asset = state.memoryImages[index];
                    return InkWell(
                      onTap: () {
                        context.read<PostCubit>().addToSelection(asset);
                      },
                      child: BlocSelector<PostCubit, PostPageState, bool>(
                        selector: (state) {
                          return state is PostPageLoaded &&
                              state.selectedImages.contains(asset);
                        },
                        builder: (context, isSelected) {
                          return Stack(
                            children: [
                              AssetThumbnail(asset: asset),
                              if (isSelected)
                                Container(
                                  color: Colors.black54,
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSelectedPictures(List<AssetEntity> selectedAssets) {
    if (selectedAssets.isEmpty) {
      return const Center(child: Icon(Icons.image));
    }

    final lastAsset = selectedAssets.last;

    return FutureBuilder<File?>(
      future: lastAsset.file,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final file = snapshot.data;
        if (file == null) {
          return const Center(child: Icon(Icons.error));
        }

        return PhotoView(imageProvider: FileImage(file));
      },
    );
  }
}
