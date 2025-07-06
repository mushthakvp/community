import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts({
    int page = 1,
    int limit = 10,
    String type = 'all',
  });

  Future<Either<Failure, bool>> likePost(String postId);

  Future<Either<Failure, List<PostEntity>>> getMyPosts();
}
