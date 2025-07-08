import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/my_post_entity.dart';

abstract class MyPostRepository {
  Future<Either<Failure, List<MyPostEntity>>> getMyPosts({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, MyPostEntity>> getPostById(String postId);

  Future<Either<Failure, bool>> likePost(String postId);

  Future<Either<Failure, bool>> deletePost(String postId);

  Future<Either<Failure, PostStatsEntity>> getPostStats();

  Future<Either<Failure, List<MyPostEntity>>> searchMyPosts(
    String query, {
    int page = 1,
    int limit = 10,
  });
}
