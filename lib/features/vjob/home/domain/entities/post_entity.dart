import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class PostEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String title;
  final String description;
  final String image;
  final List<String> likes;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLiked;

  const PostEntity({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    required this.image,
    required this.likes,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isLiked,
  });

  PostEntity copyWith({
    String? id,
    UserEntity? user,
    String? title,
    String? description,
    String? image,
    List<String>? likes,
    int? likesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
  }) {
    return PostEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    user,
    title,
    description,
    image,
    likes,
    likesCount,
    createdAt,
    updatedAt,
    isLiked,
  ];
}
