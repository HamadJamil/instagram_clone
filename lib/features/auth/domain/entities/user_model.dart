class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String>? following;
  final List<String>? followers;
  final List<String>? posts;
  final String? photoUrl;
  final String? bio;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.following,
    this.followers,
    this.photoUrl,
    this.posts,
    this.bio,
  });
}
