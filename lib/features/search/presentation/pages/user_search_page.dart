// search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/core/models/user_model.dart';
import 'package:instagram/core/theme/app_colors.dart';
import 'package:instagram/features/search/presentation/cubits/search/search_cubit.dart';
import 'package:instagram/features/search/presentation/cubits/search/search_state.dart';
import 'package:instagram/features/search/presentation/pages/other_user_page.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key, required this.userId});
  final String userId;

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search users...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<SearchCubit>().clearSearch();
              },
            ),
          ),
          onChanged: (value) {
            context.read<SearchCubit>().searchUsers(value, widget.userId);
          },
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 64, color: AppColors.grey300),
                  SizedBox(height: 16),
                  Text(
                    'Search for users',
                    style: TextStyle(color: AppColors.grey600),
                  ),
                ],
              ),
            );
          }

          if (state is SearchLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 16),
                  Text('Searching...'),
                ],
              ),
            );
          }

          if (state is SearchError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SearchCubit>().searchUsers(
                        _searchController.text,
                        widget.userId,
                      );
                    },
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is SearchLoaded) {
            final users = state.users;
            final query = state.query;
            if (users.isEmpty) {
              return Center(child: Text('No users found for "$query"'));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return UserListItem(user: user, userId: widget.userId);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final UserModel user;
  final String userId;

  const UserListItem({super.key, required this.user, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: user.photoUrl != null
            ? NetworkImage(user.photoUrl!)
            : null,
        child: user.photoUrl == null ? Icon(Icons.person, size: 24) : null,
      ),
      title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtherUserProfilePage(
              targetUserId: user.uid,
              currentUserId: userId,
            ),
          ),
        );
      },
    );
  }
}
