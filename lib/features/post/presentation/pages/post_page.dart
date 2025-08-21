import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/post/presentation/cubits/post_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/post_state.dart';
import 'package:instagram/features/post/presentation/widgets/asset_thumbnail.dart';
import 'package:photo_view/photo_view.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => PostCubit()..loadPosts(),
      child: BlocConsumer<PostCubit, PostPageState>(
        listener: (context, state) {
          if (state is PostPageError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is PostPagePermissionRequestDenied) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Permission denied')));
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,

              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
              title: const Text('New Post'),
              actions: [
                TextButton(
                  onPressed: () {
                    //////////
                  },
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            body: state is PostPageLoaded
                ? CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: size.height * 0.5,
                          child: _buildSelectedPicture(state.imageFile),
                        ),
                      ),
                      SliverAppBar(
                        titleSpacing: 5,
                        title: Text('Recent'),
                        automaticallyImplyLeading: false,
                        pinned: true,
                        actions: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.content_copy_outlined),
                          ),
                        ],
                      ),
                      SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                            ),
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          final asset = state.posts[index];
                          return index == 0
                              ? Container(
                                  color: AppColors.primary,
                                  child: Icon(Icons.camera_alt),
                                )
                              : InkWell(
                                  onTap: () {
                                    context.read<PostCubit>().selectImage(
                                      asset,
                                    );
                                  },
                                  child: AssetThumbnail(asset: asset),
                                );
                        },
                      ),
                    ],
                  )
                : Center(
                    child: SpinKitWave(color: AppColors.primary, size: 40),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedPicture(Future<File?> imageFile) {
    return FutureBuilder<File?>(
      future: imageFile.then((file) => file!),
      builder: (_, snapshot) {
        final file = snapshot.data;
        if (file == null) {
          return Center(child: Icon(Icons.image));
        }
        return PhotoView(imageProvider: FileImage(file));
      },
    );
  }
}
