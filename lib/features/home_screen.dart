import 'package:flutter/material.dart';
import 'package:instagram/features/post/presentation/pages/post_page.dart';
import 'package:instagram/features/feed/presentation/pages/feed_page.dart';
import 'package:instagram/features/profile/presentation/pages/profile_page.dart';
import 'package:instagram/features/search/presentation/pages/user_search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userId});
  final String userId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      FeedPage(userId: widget.userId),
      UserSearchPage(userId: widget.userId),
      PostPage(userId: widget.userId),
      ProfilePage(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            activeIcon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Create',
            activeIcon: Icon(Icons.add_box),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
            activeIcon: Icon(Icons.person_2),
          ),
        ],
      ),
    );
  }
}
