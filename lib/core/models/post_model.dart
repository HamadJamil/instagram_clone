import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String? caption;
  final List<String> imageUrls;
  final List<String>? likes;
  final int? comments;
  final DateTime createdAt;

  const PostModel({
    required this.imageUrls,
    this.likes,
    this.comments,
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    this.caption,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      likes: List<String>.from(json['likes'] ?? []),
      comments: json['comments'] ?? 0,
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorImage: json['authorImage'] as String?,
      caption: json['caption'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt']).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorImage': authorImage,
      'caption': caption,
      'createdAt': Timestamp.fromDate(createdAt),
      'imageUrls': imageUrls,
      'likes': likes,
      'comments': comments,
    };
  }

  PostModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorImage,
    String? caption,
    DateTime? createdAt,
    List<String>? imageUrls,
    List<String>? likes,
    int? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  int get likesCount => likes?.length ?? 0;
  bool isLikedBy(String userId) => likes?.contains(userId) ?? false;

  @override
  String toString() {
    return 'PostModel(id: $id, authorId: $authorId, authorName: $authorName, authorImage: $authorImage, caption: $caption, createdAt: $createdAt, imageUrls: $imageUrls, likes: $likes, comments: $comments)';
  }

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorImage,
    caption,
    createdAt,
    imageUrls,
    likes,
    comments,
  ];
}
