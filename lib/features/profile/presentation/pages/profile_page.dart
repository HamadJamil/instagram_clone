import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/Profile/presentation/cubits/profile_cubit.dart';
import 'package:instagram/features/profile/presentation/cubits/profile_state.dart';
import 'package:instagram/features/profile/presentation/pages/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userId});
  final String userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().load(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(child: SpinKitWave(color: AppColors.primary, size: 40));
        }
        if (state is ProfileLoaded) {
          final profileState = state;
          final user = profileState.user;
          final posts = profileState.posts;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
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
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 72,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundImage: user.photoUrl != null
                                    ? NetworkImage(user.photoUrl!)
                                    : null,
                                child: user.photoUrl == null
                                    ? Icon(Icons.person)
                                    : null,
                              ),
                              const SizedBox(width: 16.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        _buildStatItem(
                                          user.postCount.toString(),
                                          'posts',
                                        ),
                                        const SizedBox(width: 20.0),
                                        _buildStatItem(
                                          user.followers?.length.toString() ??
                                              '0',
                                          'followers',
                                        ),
                                        const SizedBox(width: 20.0),
                                        _buildStatItem(
                                          user.following?.length.toString() ??
                                              '0',
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
                        const SizedBox(height: 16.0),
                        Text(
                          user.bio ?? 'No bio available',
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 16.0),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfilePage(user: user),
                              ),
                            );
                          },
                          child: Text('Edit Profile'),
                        ),
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
                if (posts != null && posts.isNotEmpty) ...[
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: .6,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Container(
                        color: Colors.grey[300],
                        child: CachedNetworkImage(
                          imageUrl: posts[index].imageUrls[0],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      );
                    }, childCount: posts.length),
                  ),
                ] else if (posts == null) ...[
                  SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ] else if (posts.isEmpty) ...[
                  SliverFillRemaining(
                    child: Center(child: Text('Nothing available')),
                  ),
                ],
              ],
            ),
          );
        }
        return Center(child: Text('Something went wrong!'));
      },
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
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
