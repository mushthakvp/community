import '../../domain/entities/post_entity.dart';
import 'user_model.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.user,
    required super.title,
    required super.description,
    required super.image,
    required super.likes,
    required super.likesCount,
    required super.createdAt,
    required super.updatedAt,
    required super.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    try {
      return PostModel(
        id: json['_id'] ?? '',
        user: UserModel.fromJson(json['user'] ?? {}),
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        image: json['image'] ?? '',
        likes: List<String>.from(json['likes'] ?? []),
        likesCount: json['likesCount'] ?? 0,
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
        isLiked: json['isLiked'] ?? false,
      );
    } catch (e) {
      throw FormatException('Error parsing PostModel: $e');
    }
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isLiked': isLiked,
    };
  }
}
