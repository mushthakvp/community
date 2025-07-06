import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/post_response_entity.dart';

abstract class CreatePostRepository {
  Future<Either<Failure, PostResponseEntity>> createPost({
    required String title,
    required String description,
    required String image,
  });

  Future<Either<Failure, PostResponseEntity>> updatePost({
    required String postId,
    required String title,
    required String description,
    required String image,
  });

  Future<Either<Failure, bool>> deletePost(String postId);

  Future<Either<Failure, String>> uploadImage(String filePath);
}
