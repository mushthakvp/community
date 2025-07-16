import 'package:equatable/equatable.dart';

class MyPostEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? image;
  final UserEntity user;
  final int likesCount;
  final bool isLiked;
  final List<String> likes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MyPostEntity({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.user,
    required this.likesCount,
    required this.isLiked,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  MyPostEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    UserEntity? user,
    int? likesCount,
    bool? isLiked,
    List<String>? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MyPostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      user: user ?? this.user,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    image,
    user,
    likesCount,
    isLiked,
    likes,
    createdAt,
    updatedAt,
  ];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String? profileImage;

  const UserEntity({required this.id, required this.name, this.profileImage});

  @override
  List<Object?> get props => [id, name, profileImage];
}

class PostActionsEntity extends Equatable {
  final String postId;
  final PostAction action;

  const PostActionsEntity({required this.postId, required this.action});

  @override
  List<Object> get props => [postId, action];
}

enum PostAction { like, delete, share, report }

class PostStatsEntity extends Equatable {
  final int totalPosts;
  final int totalLikes;
  final int totalViews;
  final int totalComments;

  const PostStatsEntity({
    required this.totalPosts,
    required this.totalLikes,
    required this.totalViews,
    required this.totalComments,
  });

  @override
  List<Object> get props => [totalPosts, totalLikes, totalViews, totalComments];
}
