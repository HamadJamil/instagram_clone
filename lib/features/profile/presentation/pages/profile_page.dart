import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram/core/routes/app_route_name.dart';
import 'package:instagram/core/utils/toast.dart';
import 'package:instagram/features/Profile/presentation/cubits/profile_cubit.dart';

import 'package:instagram/features/profile/presentation/cubits/profile_state.dart';
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
    debugPrint('Profile Page Init State');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ToastUtils.showErrorToast(context, state.message);
        }
        if (state is ProfileLogOut) {
          ToastUtils.showSuccessToast(context, 'Logged out successfully');
          context.goNamed(AppRouteName.login);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(child: CircularProgressIndicator.adaptive());
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
                      icon: const Icon(Icons.logout_outlined),
                      onPressed: () {
                        context.read<ProfileCubit>().logOut();
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
                            context.pushNamed(
                              AppRouteName.editProfilePage,
                              extra: user,
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
                      return PostCard(
                        posts: posts,
                        post: posts[index],
                        currentUserId: user.uid,
                        index: index,
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
}
