import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final String id;
  final String userId;
  final String caption;
  final List<String> imageUrls;
  final int likes;
  final int comments;
  final DateTime createdAt;

  const PostModel({
    required this.imageUrls,
    required this.likes,
    required this.comments,
    required this.id,
    required this.userId,
    required this.caption,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      id: json['id'] as String,
      userId: json['userId'] as String,
      caption: json['caption'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'caption': caption,
      'createdAt': createdAt.toIso8601String(),
      'imageUrls': imageUrls,
      'likes': likes,
      'comments': comments,
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    String? caption,
    DateTime? createdAt,
    List<String>? imageUrls,
    int? likes,
    int? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  @override
  String toString() {
    return 'PostModel(id: $id, userId: $userId, caption: $caption, createdAt: $createdAt, imageUrls: $imageUrls, likes: $likes, comments: $comments)';
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    caption,
    createdAt,
    imageUrls,
    likes,
    comments,
  ];
}
