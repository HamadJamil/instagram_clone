import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/features/home_cubit.dart';
import 'package:instagram/features/post/presentation/pages/new_post_page.dart';
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
  late List pages;

  @override
  void initState() {
    super.initState();
    pages = [
      FeedPage(userId: widget.userId),
      UserSearchPage(userId: widget.userId),
      NewPostPage(userId: widget.userId),
      ProfilePage(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return pages[selectedIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                context.read<NavigationCubit>().navigateTo(index);
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
        },
      ),
    );
  }
}
