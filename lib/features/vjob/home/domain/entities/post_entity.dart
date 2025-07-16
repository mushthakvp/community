import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String title;
  final String description;
  final String? image;
  final List<String> likes;
  final int likesCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PostEntity({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    this.image,
    required this.likes,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
  });

  PostEntity copyWith({
    String? id,
    UserEntity? user,
    String? title,
    String? description,
    String? image,
    List<String>? likes,
    int? likesCount,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostEntity(
      id: id ?? this.id,
      user: user ?? this.user,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    isLiked,
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
