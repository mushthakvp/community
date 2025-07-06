import '../../domain/entities/job_entity.dart';
import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.user,
    required super.title,
    required super.description,
    required super.image,
    required super.likes,
    required super.likesCount,
    super.isLiked,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
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
