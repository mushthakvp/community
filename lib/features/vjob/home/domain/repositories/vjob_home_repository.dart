import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/home_job_entity.dart';
import '../entities/post_entity.dart';

abstract class VJobHomeRepository {
  Future<Either<Failure, List<HomeJobEntity>>> getJobs({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, bool>> saveJob(String jobId);

  Future<Either<Failure, bool>> applyJob(String jobId);

  Future<Either<Failure, List<PostEntity>>> getPosts({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, List<PostEntity>>> getMyPosts();

  Future<Either<Failure, bool>> likePost(String postId);

  Future<Either<Failure, bool>> deletePost(String postId);
}
