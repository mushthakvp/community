import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/my_post_entity.dart';
import '../../domain/repositories/my_post_repository.dart';
import '../datasources/my_post_local_datasource.dart';
import '../datasources/my_post_remote_datasource.dart';

class MyPostRepositoryImpl implements MyPostRepository {
  final MyPostRemoteDataSource remoteDataSource;
  final MyPostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MyPostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MyPostEntity>>> getMyPosts({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final posts = await remoteDataSource.getMyPosts(
          page: page,
          limit: limit,
        );

        // Cache the first page only
        if (page == 1) {
          await localDataSource.cacheMyPosts(posts);
        }

        return Right(posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedPosts = await localDataSource.getCachedMyPosts();
        return Right(cachedPosts);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, MyPostEntity>> getPostById(String postId) async {
    if (await networkInfo.isConnected) {
      try {
        final post = await remoteDataSource.getPostById(postId);

        // Cache the individual post
        await localDataSource.cachePost(post);

        return Right(post);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedPost = await localDataSource.getCachedPostById(postId);
        if (cachedPost != null) {
          return Right(cachedPost);
        } else {
          return const Left(CacheFailure(message: 'Post not found in cache'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> likePost(String postId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.likePost(postId);

        if (result) {
          // Update cached post if exists
          final cachedPost = await localDataSource.getCachedPostById(postId);
          if (cachedPost != null) {
            final updatedPost = cachedPost.copyWith(
              isLiked: !cachedPost.isLiked,
              likesCount: cachedPost.isLiked
                  ? cachedPost.likesCount - 1
                  : cachedPost.likesCount + 1,
            );
            await localDataSource.updatePostInCache(updatedPost);
          }
        }

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

        if (result) {
          // Remove from cache
          await localDataSource.removePostFromCache(postId);
        }

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
  Future<Either<Failure, PostStatsEntity>> getPostStats() async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getPostStats();

        // Cache the stats
        await localDataSource.cachePostStats(stats);

        return Right(stats);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedStats = await localDataSource.getCachedPostStats();
        if (cachedStats != null) {
          return Right(cachedStats);
        } else {
          return const Left(CacheFailure(message: 'Stats not found in cache'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<MyPostEntity>>> searchMyPosts(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final posts = await remoteDataSource.searchMyPosts(
          query,
          page: page,
          limit: limit,
        );

        return Right(posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        // Search in cached posts
        final cachedPosts = await localDataSource.getCachedMyPosts();
        final filteredPosts = cachedPosts.where((post) {
          return post.title.toLowerCase().contains(query.toLowerCase()) ||
              post.description.toLowerCase().contains(query.toLowerCase());
        }).toList();

        return Right(filteredPosts);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  // Additional helper methods
  Future<Either<Failure, void>> clearPostsCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<Either<Failure, void>> refreshPosts() async {
    if (await networkInfo.isConnected) {
      try {
        // Clear cache first
        await localDataSource.clearCache();

        // Fetch fresh data
        final posts = await remoteDataSource.getMyPosts(page: 1, limit: 10);
        await localDataSource.cacheMyPosts(posts);

        return const Right(null);
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
