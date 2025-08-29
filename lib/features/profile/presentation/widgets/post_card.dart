import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/theme/app_colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: post.imageUrls[0],
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
          if (post.imageUrls.length > 1) ...[
            Positioned(
              right: 8,
              top: 5,
              child: Icon(Icons.square_rounded, color: Colors.white, size: 16),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Icon(Icons.square_rounded, color: Colors.black, size: 16),
            ),
            Positioned(
              right: 5,
              top: 7,
              child: Icon(Icons.square_rounded, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}
