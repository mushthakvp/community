import '../../domain/entities/my_post_entity.dart';

class MyPostModel extends MyPostEntity {
  const MyPostModel({
    required super.id,
    required super.title,
    required super.description,
    super.image,
    required super.user,
    required super.likesCount,
    required super.isLiked,
    required super.likes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MyPostModel.fromJson(Map<String, dynamic> json) {
    return MyPostModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      user: UserModel.fromJson(json['user'] ?? {}),
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      likes: List<String>.from(json['likes'] ?? []),
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
      'title': title,
      'description': description,
      'image': image,
      'user': (user as UserModel).toJson(),
      'likesCount': likesCount,
      'isLiked': isLiked,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  MyPostModel copyWith({
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
    return MyPostModel(
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

class PostStatsModel extends PostStatsEntity {
  const PostStatsModel({
    required super.totalPosts,
    required super.totalLikes,
    required super.totalViews,
    required super.totalComments,
  });

  factory PostStatsModel.fromJson(Map<String, dynamic> json) {
    return PostStatsModel(
      totalPosts: json['totalPosts'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      totalComments: json['totalComments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPosts': totalPosts,
      'totalLikes': totalLikes,
      'totalViews': totalViews,
      'totalComments': totalComments,
    };
  }
}

class MyPostsResponseModel {
  final bool success;
  final String message;
  final List<MyPostModel> posts;
  final int totalPages;
  final int currentPage;
  final int totalCount;

  MyPostsResponseModel({
    required this.success,
    required this.message,
    required this.posts,
    required this.totalPages,
    required this.currentPage,
    required this.totalCount,
  });

  factory MyPostsResponseModel.fromJson(Map<String, dynamic> json) {
    return MyPostsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      posts:
          (json['posts'] as List?)
              ?.map((post) => MyPostModel.fromJson(post))
              .toList() ??
          [],
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
    );
  }
}

class PostActionResponseModel {
  final bool success;
  final String message;
  final MyPostModel? post;

  PostActionResponseModel({
    required this.success,
    required this.message,
    this.post,
  });

  factory PostActionResponseModel.fromJson(Map<String, dynamic> json) {
    return PostActionResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      post: json['post'] != null ? MyPostModel.fromJson(json['post']) : null,
    );
  }
}

class PostStatsResponseModel {
  final bool success;
  final String message;
  final PostStatsModel stats;

  PostStatsResponseModel({
    required this.success,
    required this.message,
    required this.stats,
  });

  factory PostStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return PostStatsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      stats: PostStatsModel.fromJson(json['stats'] ?? {}),
    );
  }
}
