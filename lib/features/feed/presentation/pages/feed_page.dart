import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/utils/toast.dart';
import 'package:instagram/features/feed/presentation/cubits/feed/feed_cubit.dart';
import 'package:instagram/features/feed/presentation/cubits/feed/feed_state.dart';
import 'package:instagram/features/feed/presentation/widgets/post_tile.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.userId});
  final String userId;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = widget.userId;
    context.read<FeedCubit>().subscribeToFeed();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<FeedCubit>().loadMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('𝕴𝖓𝖘𝖙𝖆𝖌𝖗𝖆𝖒', style: TextStyle(fontSize: 28)),
      ),
      body: BlocConsumer<FeedCubit, FeedState>(
        listener: (context, state) {
          if (state is FeedError) {
            ToastUtils.showErrorToast(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is FeedInitial || state is FeedLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FeedLoaded) {
            if (state.posts.isEmpty) {
              return Center(child: Text('No Posts Available'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<FeedCubit>().refreshFeed();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.posts.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.posts.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return PostTile(
                    post: state.posts[index],
                    currentUserId: currentUserId,
                  );
                },
              ),
            );
          } else if (state is FeedLoadingMore) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.currentPosts.length + 1,
              itemBuilder: (context, index) {
                if (index == state.currentPosts.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return PostTile(
                  post: state.currentPosts[index],
                  currentUserId: currentUserId,
                );
              },
            );
          }
          return SizedBox(child: Center(child: Text('No Posts Available')));
        },
      ),
    );
  }
}
