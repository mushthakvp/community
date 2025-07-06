import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/home_job_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/vjob_home_repository.dart';
import '../datasources/vjob_home_local_datasource.dart';
import '../datasources/vjob_home_remote_datasource.dart';

class VJobHomeRepositoryImpl implements VJobHomeRepository {
  final VJobHomeRemoteDataSource remoteDataSource;
  final VJobHomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  VJobHomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<HomeJobEntity>>> getJobs({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getJobs(page: page, limit: limit);

        // Cache the first page only
        if (page == 1) {
          await localDataSource.cacheJobs(result.jobs);
        }

        return Right(result.jobs);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedJobs = await localDataSource.getCachedJobs();
        return Right(cachedJobs);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> saveJob(String jobId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.saveJob(jobId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> applyJob(String jobId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.applyJob(jobId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPosts(
          page: page,
          limit: limit,
        );

        // Cache the first page only
        if (page == 1) {
          await localDataSource.cachePosts(result.posts);
        }

        return Right(result.posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedPosts = await localDataSource.getCachedPosts();
        return Right(cachedPosts);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getMyPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyPosts();
        return Right(result.posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> likePost(String postId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.likePost(postId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePost(String postId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.deletePost(postId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
