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
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: pages(),

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

  Widget pages() {
    switch (selectedIndex) {
      case 0:
        return const FeedPage();
      case 1:
        return UserSearchPage(userId: widget.userId);
      case 2:
        return PostPage(userId: widget.userId);
      case 3:
        return ProfilePage(userId: widget.userId);
      default:
        return const FeedPage();
    }
  }
}
