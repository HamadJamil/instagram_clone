import 'package:flutter/material.dart';
import 'package:instagram/features/home/presentation/pages/post_page.dart';
import 'package:instagram/features/home/presentation/pages/profile_page.dart';
import 'package:photo_manager/photo_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: selectedIndex == 0
          ? Center(child: Text('Home Content Here'))
          : ProfilePage(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PhotoManager.requestPermissionExtend().then((result) {
            if (!context.mounted) return;
            if (result.isAuth) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostPage()),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Permission denied')));
            }
          });
        },
        child: Icon(Icons.add),
      ),
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
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
            activeIcon: Icon(Icons.person_2),
          ),
        ],
      ),
    );
  }
}
