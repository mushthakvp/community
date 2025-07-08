import 'package:equatable/equatable.dart';

class CreatePostEntity extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String? image;
  final UserEntity? user;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final bool isLiked;

  const CreatePostEntity({
    this.id,
    required this.title,
    required this.description,
    this.image,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.isLiked = false,
  });

  CreatePostEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    UserEntity? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    bool? isLiked,
  }) {
    return CreatePostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    image,
    user,
    createdAt,
    updatedAt,
    likesCount,
    isLiked,
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

class CreatePostRequest extends Equatable {
  final String title;
  final String description;
  final String? image;

  const CreatePostRequest({
    required this.title,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [title, description, image];
}

class UpdatePostRequest extends Equatable {
  final String postId;
  final String title;
  final String description;
  final String? image;

  const UpdatePostRequest({
    required this.postId,
    required this.title,
    required this.description,
    this.image,
  });

  @override
  List<Object?> get props => [postId, title, description, image];
}
