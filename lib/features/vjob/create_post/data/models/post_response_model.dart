import '../../domain/entities/post_response_entity.dart';

class PostResponseModel extends PostResponseEntity {
  const PostResponseModel({
    required super.success,
    required super.message,
    super.postId,
  });

  factory PostResponseModel.fromJson(Map<String, dynamic> json) {
    return PostResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      postId: json['postId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'postId': postId};
  }
}
