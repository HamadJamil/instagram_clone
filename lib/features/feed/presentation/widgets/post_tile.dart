import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/repository/post_repository.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/feed/presentation/cubits/like/like_cubit.dart';
import 'package:instagram/features/feed/presentation/cubits/like/like_state.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post, required this.currentUserId});
  final PostModel post;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LikeCubit(
        postId: post.id,
        userId: currentUserId,
        postRepository: PostRepository(FirebaseFirestore.instance),
      ),
      child: _PostTileContent(post: post, currentUserId: currentUserId),
    );
  }
}

class _PostTileContent extends StatelessWidget {
  const _PostTileContent({required this.post, required this.currentUserId});
  final PostModel post;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LikeCubit, LikeState>(
      listener: (context, state) {
        if (state is LikeError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final likesCount = state is LikeLoaded
            ? state.likesCount
            : post.likesCount;
        final isLiked = state is LikeLoaded
            ? state.isLiked
            : post.isLikedBy(currentUserId);

        return _buildPostContent(context, likesCount, isLiked);
      },
    );
  }

  Widget _buildPostContent(BuildContext context, int likesCount, bool isLiked) {
    final theme = Theme.of(context);
    final isMultiImage = post.imageUrls.length > 1;
    final commentCount = post.comments ?? 0;

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.grey400,
                  child: ClipOval(
                    child: post.authorImage != null
                        ? CachedNetworkImage(
                            imageUrl: post.authorImage!,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[200]),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person, size: 18),
                          )
                        : const Icon(Icons.person, size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    post.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Post images with List for multiple images
          Stack(
            children: [
              Container(
                height: 375,
                width: double.infinity,
                color: AppColors.grey400,
                child: GestureDetector(
                  onDoubleTap: () {
                    if (!isLiked) {
                      context.read<LikeCubit>().toggleLike();
                      _showLikeAnimation(context);
                    }
                  },
                  child: isMultiImage
                      ? PageView.builder(
                          itemCount: post.imageUrls.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: post.imageUrls[index],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            );
                          },
                        )
                      : CachedNetworkImage(
                          imageUrl: post.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[200]),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                ),
              ),
              if (isMultiImage)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '1/${post.imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey<bool>(isLiked),
                          size: 28,
                          color: isLiked ? Colors.red : null,
                        ),
                      ),
                      onPressed: () => context.read<LikeCubit>().toggleLike(),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.mode_comment_outlined, size: 28),
                      onPressed: () {
                        _showCommentsSection(context);
                      },
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.send_outlined, size: 28),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, size: 28),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          // Likes count
          if (likesCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$likesCount ${likesCount == 1 ? 'like' : 'likes'}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),

          // Caption with username
          if (post.caption != null && post.caption!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${post.authorName} ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onBackground,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: post.caption!,
                      style: TextStyle(
                        color: theme.colorScheme.onBackground,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Comments preview
          if (commentCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: GestureDetector(
                onTap: () => _showCommentsSection(context),
                child: Text(
                  'View all $commentCount comments',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ),
            ),

          // Timestamp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Text(
              GetTimeAgo.parse(post.createdAt),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _showLikeAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: Icon(
            Icons.favorite,
            size: 100,
            color: Colors.red.withValues(alpha: 0.8),
          ),
        );
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pop();
    });
  }

  void _showCommentsSection(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            children: [
              Text(
                'Comments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: post.comments ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.grey400,
                        child: const Icon(Icons.person, size: 20),
                      ),
                      title: Text('User $index'),
                      subtitle: Text('This is comment number $index'),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          hintText: 'Add a comment...',
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(right: 12.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.grey400,
                            ),
                            child: const Icon(Icons.person, size: 20),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                //////////////////////
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
