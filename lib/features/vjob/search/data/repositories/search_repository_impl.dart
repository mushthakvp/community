import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/recent_search_entity.dart';
import '../../domain/entities/search_job_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RecentSearchesResponseEntity>>
  getRecentSearches() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getRecentSearches();
        await localDataSource.cacheRecentSearches(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedSearches = await localDataSource.getCachedRecentSearches();
        if (cachedSearches != null) {
          return Right(cachedSearches);
        }
        return const Left(CacheFailure(message: 'No cached data available'));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, SearchJobsResponseEntity>> searchJobs({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.searchJobs(
          query: query,
          page: page,
          limit: limit,
        );
        if (page == 1) {
          await localDataSource.cacheSearchResults(query, result);
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
      try {
        if (page == 1) {
          final cachedResults = await localDataSource.getCachedSearchResults(
            query,
          );
          if (cachedResults != null) {
            return Right(cachedResults);
          }
        }
        return const Left(NetworkFailure(message: 'No internet connection'));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }
}
