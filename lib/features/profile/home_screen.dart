import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/features/profile/presentation/pages/home_page.dart';
import 'package:instagram/features/profile/presentation/pages/profile_page.dart';

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
      body: selectedIndex == 0 ? HomePage() : ProfilePage(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRouteName.createPost);
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
