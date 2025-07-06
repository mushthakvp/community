import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.user,
    required super.title,
    required super.description,
    super.image,
    required super.likes,
    required super.likesCount,
    required super.isLiked,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      likes: List<String>.from(json['likes'] ?? []),
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': (user as UserModel).toJson(),
      'title': title,
      'description': description,
      'image': image,
      'likes': likes,
      'likesCount': likesCount,
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.name, super.profileImage});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profileImage': profileImage};
  }
}

class PostsResponseModel {
  final bool success;
  final List<PostModel> posts;
  final String message;
  final int totalPages;

  PostsResponseModel({
    required this.success,
    required this.posts,
    required this.message,
    required this.totalPages,
  });

  factory PostsResponseModel.fromJson(Map<String, dynamic> json) {
    return PostsResponseModel(
      success: json['success'] ?? false,
      posts:
          (json['posts'] as List?)
              ?.map((post) => PostModel.fromJson(post))
              .toList() ??
          [],
      message: json['message'] ?? '',
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
