import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/create_post_entity.dart';

abstract class CreatePostRepository {
  Future<Either<Failure, CreatePostEntity>> createPost(
    CreatePostRequest request,
  );

  Future<Either<Failure, CreatePostEntity>> updatePost(
    UpdatePostRequest request,
  );

  Future<Either<Failure, String>> uploadImage(String imagePath);

  Future<Either<Failure, bool>> deletePost(String postId);
}
