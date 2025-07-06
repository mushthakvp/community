import 'post_model.dart';

class PostsResponseModel {
  final bool success;
  final List<PostModel> posts;
  final String message;
  final int totalPages;

  const PostsResponseModel({
    required this.success,
    required this.posts,
    required this.message,
    required this.totalPages,
  });

  factory PostsResponseModel.fromJson(Map<String, dynamic> json) {
    return PostsResponseModel(
      success: json['success'] ?? false,
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((post) => PostModel.fromJson(post))
              .toList() ??
          [],
      message: json['message'] ?? '',
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
