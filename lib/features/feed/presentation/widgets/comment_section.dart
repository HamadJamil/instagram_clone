import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/utils/toast.dart';
import 'package:instagram/features/feed/presentation/cubits/comment/comment_cubit.dart';
import 'package:instagram/features/feed/presentation/cubits/comment/comment_state.dart';
import 'package:instagram/features/feed/presentation/widgets/comment_input.dart';
import 'package:instagram/features/feed/presentation/widgets/comment_tile.dart';

class CommentSection extends StatelessWidget {
  final PostModel post;
  final String currentUserId;

  const CommentSection({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentCubit, CommentState>(
      listener: (context, state) {
        if (state is CommentError) {
          ToastUtils.showErrorToast(context, state.message);
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
            CommentInput(
              onSend: (content) {
                context.read<CommentCubit>().addComment(content);
              },
            ),
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
          return CommentTile(comment: comment);
        },
      );
    }
    return SizedBox(child: Center(child: Text('No comments yet')));
  }
}
