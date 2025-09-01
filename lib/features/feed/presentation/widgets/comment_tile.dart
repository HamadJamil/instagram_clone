import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/feed/presentation/cubits/comment/comment_cubit.dart';
import 'package:instagram/features/feed/presentation/cubits/comment/comment_state.dart';

class CommentTile extends StatelessWidget {
  final PostModel post;
  final String currentUserId;

  const CommentTile({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentCubit, CommentState>(
      listener: (context, state) {
        if (state is CommentError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Text(
              'Comments',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),
            Expanded(child: _buildCommentsList(context, state)),
            _buildCommentInput(context),
          ],
        );
      },
    );
  }

  Widget _buildCommentsList(BuildContext context, CommentState state) {
    if (state is CommentInitial || state is CommentLoading) {
      return Center(child: CircularProgressIndicator());
    } else if ((state is CommentLoaded && state.comments.isNotEmpty) ||
        state is CommentLoadingMore) {
      final comments = state is CommentLoaded
          ? state.comments
          : (state as CommentLoadingMore).currentComments;
      final hasMore = state is CommentLoaded
          ? state.hasMore
          : (state as CommentLoadingMore).hasMore;

      return ListView.builder(
        itemCount: comments.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == comments.length) {
            return Center(child: CircularProgressIndicator());
          }
          final comment = comments[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.grey400,
              child: comment.authorAvatar != null
                  ? CachedNetworkImage(
                      imageUrl: comment.authorAvatar!,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.person, size: 20),
            ),
            title: Text(comment.authorName),
            subtitle: Text(comment.text),
          );
        },
      );
    }
    return SizedBox(child: Center(child: Text('No comments yet')));
  }

  Widget _buildCommentInput(BuildContext context) {
    final textController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isNotEmpty) {
                        context.read<CommentCubit>().addComment(text);
                        textController.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
