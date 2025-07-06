import 'package:equatable/equatable.dart';

class PostResponseEntity extends Equatable {
  final bool success;
  final String message;
  final String? postId;

  const PostResponseEntity({
    required this.success,
    required this.message,
    this.postId,
  });

  PostResponseEntity copyWith({
    bool? success,
    String? message,
    String? postId,
  }) {
    return PostResponseEntity(
      success: success ?? this.success,
      message: message ?? this.message,
      postId: postId ?? this.postId,
    );
  }

  @override
  List<Object?> get props => [success, message, postId];

  @override
  String toString() {
    return 'PostResponseEntity(success: $success, message: $message, postId: $postId)';
  }
}
