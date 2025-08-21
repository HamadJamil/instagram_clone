import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final List<String>? following;
  final List<String>? followers;
  final List<String>? posts;
  final String? photoUrl;
  final String? bio;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.following,
    this.followers,
    this.photoUrl,
    this.posts,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      following: List<String>.from(json['following'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
      photoUrl: json['photoUrl'],
      posts: List<String>.from(json['posts'] ?? []),
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'following': following,
      'followers': followers,
      'photoUrl': photoUrl,
      'posts': posts,
      'bio': bio,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    List<String>? following,
    List<String>? followers,
    String? photoUrl,
    List<String>? posts,
    String? bio,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      photoUrl: photoUrl ?? this.photoUrl,
      posts: posts ?? this.posts,
      bio: bio ?? this.bio,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, following: $following, followers: $followers, photoUrl: $photoUrl, posts: $posts, bio: $bio)';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    uid,
    name,
    email,
    following,
    followers,
    photoUrl,
    posts,
    bio,
  ];
}
