import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_data_source.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, SearchResult>> searchChallenges({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Try cache first for page 1
      if (page == 1) {
        final cachedResult = await localDataSource.getCachedSearchResult(query);
        if (cachedResult != null) {
          return Right(cachedResult);
        }
      }

      // Fetch from remote
      final result = await remoteDataSource.searchChallenges(
        query: query,
        page: page,
        limit: limit,
      );

      // Cache first page results
      if (page == 1) {
        await localDataSource.cacheSearchResult(result);
      }

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions(
    String query,
  ) async {
    try {
      final suggestions = await remoteDataSource.getSearchSuggestions(query);
      return Right(suggestions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    await localDataSource.saveRecentSearch(query);
  }

  @override
  Future<List<String>> getRecentSearches() async {
    return await localDataSource.getRecentSearches();
  }

  @override
  Future<void> clearRecentSearches() async {
    await localDataSource.clearRecentSearches();
  }
}
