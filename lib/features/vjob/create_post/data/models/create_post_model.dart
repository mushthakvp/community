import '../../domain/entities/create_post_entity.dart';

class CreatePostModel extends CreatePostEntity {
  const CreatePostModel({
    required super.title,
    required super.description,
    super.id,
    super.image,
    super.user,
    super.createdAt,
    super.updatedAt,
    super.likesCount,
    super.isLiked,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) {
    return CreatePostModel(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image': image,
      'user': user != null ? (user as UserModel).toJson() : null,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likesCount': likesCount,
      'isLiked': isLiked,
    };
  }

  @override
  CreatePostModel copyWith({
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
    return CreatePostModel(
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
}

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.name, super.profileImage});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profileImage': profileImage};
  }
}

class CreatePostRequestModel extends CreatePostRequest {
  const CreatePostRequestModel({
    required super.title,
    required super.description,
    super.image,
  });

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'image': image};
  }
}

class UpdatePostRequestModel extends UpdatePostRequest {
  const UpdatePostRequestModel({
    required super.postId,
    required super.title,
    required super.description,
    super.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'action': 'update',
      'title': title,
      'description': description,
      'image': image,
    };
  }
}

class CreatePostResponseModel {
  final bool success;
  final String message;
  final CreatePostModel? post;

  CreatePostResponseModel({
    required this.success,
    required this.message,
    this.post,
  });

  factory CreatePostResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatePostResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      post: json['post'] != null
          ? CreatePostModel.fromJson(json['post'])
          : null,
    );
  }
}
