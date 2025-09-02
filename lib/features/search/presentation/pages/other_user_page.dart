import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/post_model.dart';
import 'package:instagram/features/feed/presentation/widgets/post_tile.dart';
import 'package:instagram/features/profile/presentation/widgets/post_card.dart';
import 'package:instagram/features/profile/presentation/widgets/stat_item.dart';
import 'package:instagram/features/search/presentation/cubits/otheruser/otherUser_state.dart';
import 'package:instagram/features/search/presentation/cubits/otheruser/otheruser_cubit.dart';

class OtherUserProfilePage extends StatefulWidget {
  final String targetUserId;
  final String currentUserId;

  const OtherUserProfilePage({
    super.key,
    required this.targetUserId,
    required this.currentUserId,
  });

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<OtherUserProfileCubit>().loadUserProfile(
      widget.targetUserId,
      widget.currentUserId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtherUserProfileCubit, OtherUserProfileState>(
      listener: (context, state) {
        if (state is OtherUserProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is OtherUserProfileLoading) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile')),
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (state is OtherUserProfileError) {
          return Scaffold(
            appBar: AppBar(title: Text('Profile')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load profile'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<OtherUserProfileCubit>()
                        .refresh(widget.targetUserId, widget.currentUserId),
                    child: Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is OtherUserProfileLoaded) {
          final user = state.user;
          final posts = state.posts;
          final isFollowing = state.isFollowing;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('${user.name.toLowerCase()}_'),
                  floating: true,
                  centerTitle: false,
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
                        _buildActionButton(isFollowing, user.uid),
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
                  automaticallyImplyLeading: false,
                ),

                if (posts.isNotEmpty) ...[
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
                          _postDetailView(posts[index], widget.currentUserId);
                        },
                        child: PostCard(post: posts[index]),
                      );
                    }, childCount: posts.length),
                  ),
                ] else ...[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('No posts available')),
                  ),
                ],
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text('Profile')),
          body: Center(child: Text('Something went wrong!')),
        );
      },
    );
  }

  Widget _buildActionButton(bool isFollowing, String targetUserId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (isFollowing) {
            context.read<OtherUserProfileCubit>().unfollowUser(
              targetUserId,
              widget.currentUserId,
            );
          } else {
            context.read<OtherUserProfileCubit>().followUser(
              targetUserId,
              widget.currentUserId,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isFollowing ? Colors.grey[300] : Colors.blue,
          foregroundColor: isFollowing ? Colors.black : Colors.white,
        ),
        child: Text(isFollowing ? 'Following' : 'Follow'),
      ),
    );
  }

  void _postDetailView(PostModel post, String currentUserId) {
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
