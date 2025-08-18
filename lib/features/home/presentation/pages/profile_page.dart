import 'package:flutter/material.dart';
import 'package:instagram/core/widgets/custom_outlined_button.dart';
import 'package:instagram/features/auth/domain/entities/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = UserModel(
      uid: '123',
      name: 'John Doe',
      email: 'johndoe@example.com',
      following: ['456', '789'],
      followers: ['321', '654'],
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actionsPadding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            title: Text('${user.name.toLowerCase()}_'),
            floating: true,
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  /////////////////
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.1,
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 37,
                              backgroundImage: user.photoUrl != null
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null
                                  ? Icon(Icons.person)
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Icon(Icons.add_circle, size: 30),
                            ),
                          ],
                        ),
                        SizedBox(width: size.width * 0.06),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  _buildStatItem(
                                    user.posts?.length.toString() ?? '0',
                                    'posts',
                                  ),
                                  SizedBox(width: size.width * 0.07),
                                  _buildStatItem(
                                    user.followers?.length.toString() ?? '0',
                                    'followers',
                                  ),
                                  SizedBox(width: size.width * 0.07),
                                  _buildStatItem(
                                    user.following?.length.toString() ?? '0',
                                    'following',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    user.bio ?? 'No bio available',
                    style: TextStyle(fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.02),
                  CustomOutlinedButton(onPressed: () {}, label: 'Edit Profile'),
                ],
              ),
            ),
          ),
          const SliverAppBar(
            title: Row(
              children: [
                Icon(Icons.grid_on),
                SizedBox(width: 8),
                Text('Posts'),
              ],
            ),
            floating: true,
            pinned: true,
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: .6,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                color: Colors.grey[300],
                child: Center(child: Text('Post $index')),
              );
            }, childCount: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
