import 'package:flutter/material.dart';
import 'package:instagram/features/post/domain/entities/post_model.dart';
import 'package:instagram/features/profile/presentation/widgets/post_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> samplePosts = [
    PostModel(
      id: 'post_1',
      userId: 'user_1',
      caption: 'Beautiful sunset at the beach! 🌅 #sunset #beach',
      imageUrls: [
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
      ],
      likes: 156,
      comments: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PostModel(
      id: 'post_2',
      userId: 'user_2',
      caption: 'Coffee and coding ☕️💻 #developer #coding',
      imageUrls: [
        'https://images.unsplash.com/photo-1461749280684-dccba630e2f6',
      ],
      likes: 89,
      comments: 5,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    PostModel(
      id: 'post_3',
      userId: 'user_3',
      caption: 'Morning hike with amazing views! 🏔️ #hiking #nature',
      imageUrls: [
        'https://images.unsplash.com/photo-1551632811-561732d1e306',
        'https://images.unsplash.com/photo-1418065460487-3e41a6c84dc5',
      ],
      likes: 234,
      comments: 23,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PostModel(
      id: 'post_4',
      userId: 'user_4',
      caption:
          'New book arrived! Can\'t wait to start reading 📚 #books #reading',
      imageUrls: ['https://images.unsplash.com/photo-1544947950-fa07a98d237f'],
      likes: 67,
      comments: 8,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    PostModel(
      id: 'post_5',
      userId: 'user_1',
      caption: 'Weekend vibes 🎶 #music #weekend',
      imageUrls: [
        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745',
      ],
      likes: 312,
      comments: 45,
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
    ),
    PostModel(
      id: 'post_6',
      userId: 'user_5',
      caption: 'Homemade pizza night! 🍕 #food #cooking',
      imageUrls: [
        'https://images.unsplash.com/photo-1513104890138-7c749659a591',
        'https://images.unsplash.com/photo-1574071318508-1cdbab80d002',
      ],
      likes: 189,
      comments: 34,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    PostModel(
      id: 'post_7',
      userId: 'user_6',
      caption: 'City lights never get old 🌃 #city #urban',
      imageUrls: [
        'https://images.unsplash.com/photo-1449824913935-59a10b8d2000',
      ],
      likes: 278,
      comments: 29,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    PostModel(
      id: 'post_8',
      userId: 'user_7',
      caption: 'Workout complete! 💪 #fitness #gym',
      imageUrls: [
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
      ],
      likes: 142,
      comments: 15,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    PostModel(
      id: 'post_9',
      userId: 'user_3',
      caption: 'Pet love 🐶❤️ #dog #pet',
      imageUrls: ['https://images.unsplash.com/photo-1552053831-71594a27632d'],
      likes: 423,
      comments: 67,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    PostModel(
      id: 'post_10',
      userId: 'user_2',
      caption: 'Sunrise from my window 🌄 #morning #sunrise',
      imageUrls: [
        'https://images.unsplash.com/photo-1498496294614-acc1be1c5dff',
      ],
      likes: 198,
      comments: 18,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
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
          SliverList.builder(
            itemCount: samplePosts.length,
            itemBuilder: (context, index) {
              final post = samplePosts[index];
              return PostTile(post: post);
            },
          ),
        ],
      ),
    );
  }
}
