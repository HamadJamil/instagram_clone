import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final List<String>? following;
  final List<String>? followers;
  final int? postCount;
  final String? photoUrl;
  final String? bio;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.following,
    this.followers,
    this.photoUrl,
    this.postCount,
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
      postCount: json['postCount'] ?? 0,
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
      'postCount': postCount,
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
    int? postCount,
    String? bio,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      photoUrl: photoUrl ?? this.photoUrl,
      postCount: postCount ?? this.postCount,
      bio: bio ?? this.bio,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, following: $following, followers: $followers, photoUrl: $photoUrl, postCount: $postCount , bio: $bio)';
  }

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    following,
    followers,
    photoUrl,
    postCount,
    bio,
  ];
}
