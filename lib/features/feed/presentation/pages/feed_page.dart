import 'package:flutter/material.dart';
// import 'package:instagram/features/post/domain/entities/post_model.dart';
// import 'package:instagram/features/feed/presentation/widgets/post_tile.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text('Instagram'),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none),
                onPressed: () {},
              ),
            ],
          ),
          // SliverList.builder(
          //   itemCount: samplePosts.length,
          //   itemBuilder: (context, index) {
          //     final post = samplePosts[index];
          //     return PostTile(post: post);
          //   },
          // ),
        ],
      ),
    );
  }
}
