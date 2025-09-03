import 'package:flutter/material.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/features/feed/presentation/widgets/post_tile.dart';

class PostDetailScreen extends StatefulWidget {
  final List<PostModel> posts;
  final int initialIndex;
  final String currentUserId;

  const PostDetailScreen({
    super.key,
    required this.posts,
    required this.initialIndex,
    required this.currentUserId,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: widget.posts.length,

        itemBuilder: (context, index) {
          return PostTile(
            post: widget.posts[index],
            currentUserId: widget.currentUserId,
          );
        },
      ),
    );
  }
}
