import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/Profile/presentation/cubits/profile_cubit.dart';
import 'package:instagram/features/feed/presentation/widgets/post_tile.dart';
import 'package:instagram/features/profile/presentation/cubits/profile_state.dart';
import 'package:instagram/features/profile/presentation/pages/edit_profile.dart';
import 'package:instagram/features/profile/presentation/widgets/post_card.dart';
import 'package:instagram/features/profile/presentation/widgets/stat_item.dart';

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
                                        StatItem(
                                          value: user.postCount.toString(),
                                          label: 'posts',
                                        ),
                                        const SizedBox(width: 20.0),
                                        StatItem(
                                          value:
                                              user.followers?.length
                                                  .toString() ??
                                              '0',
                                          label: 'followers',
                                        ),
                                        const SizedBox(width: 20.0),
                                        StatItem(
                                          value:
                                              user.following?.length
                                                  .toString() ??
                                              '0',
                                          label: 'following',
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
                          childAspectRatio: .725,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return InkWell(
                        onLongPress: () {
                          postDetailView(posts[index], widget.userId);
                        },
                        child: PostCard(post: posts[index]),
                      );
                    }, childCount: posts.length),
                  ),
                ] else if (posts == null) ...[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ] else if (posts.isEmpty) ...[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No posts available')),
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

  void postDetailView(PostModel post, String currentUserId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: PostTile(post: post, currentUserId: currentUserId),
        );
      },
    );
  }
}
