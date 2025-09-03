import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/home_cubit.dart';
import 'package:instagram/features/post/presentation/cubits/post/post_cubit.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.posts,
    required this.index,
  });
  final PostModel post;
  final String currentUserId;
  final List<PostModel> posts;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRouteName.postDetailScreen,
        extra: {
          'posts': posts,
          'initialIndex': index,
          'currentUserId': currentUserId,
        },
      ),
      onLongPress: () => post.authorId == currentUserId
          ? _showPostEditBottomSheet(context)
          : null,
      child: Container(
        color: AppColors.grey300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'post-image-${post.id}',
              child: CachedNetworkImage(
                imageUrl: post.imageUrls[0],
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
            if (post.imageUrls.length > 1) ...[
              Positioned(
                right: 8,
                top: 5,
                child: Icon(
                  Icons.square_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Icon(
                  Icons.square_rounded,
                  color: Colors.black,
                  size: 16,
                ),
              ),
              Positioned(
                right: 5,
                top: 7,
                child: Icon(
                  Icons.square_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPostEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        return Container(
          height: 152,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text('Edit Photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  context.pushNamed(AppRouteName.editPostPage, extra: post);
                },
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text('Delete Photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  context.read<PostCubit>().deletePost(
                    post.id,
                    post.authorId,
                    post.imageUrls,
                  );
                  context.read<NavigationCubit>().navigateToProfile();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
