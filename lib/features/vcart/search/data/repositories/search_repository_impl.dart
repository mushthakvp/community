import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/search_data.dart';
import '../../domain/entities/search_results.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_remote_datasource.dart';
import '../models/search_data_model.dart';

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
  Future<Either<Failure, SearchData>> getSearchData() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteData = await remoteDataSource.getSearchData();
          await localDataSource.cacheSearchData(remoteData);
          return Right(remoteData);
        } catch (e) {
          final cachedData = await localDataSource.getCachedSearchData();
          if (cachedData != null) {
            return Right(cachedData);
          } else {
            return Left(_handleException(e));
          }
        }
      } else {
        final cachedData = await localDataSource.getCachedSearchData();
        if (cachedData != null) {
          return Right(cachedData);
        } else {
          return const Left(
            NetworkFailure(
              message: 'No internet connection and no cached data available',
            ),
          );
        }
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteData = await remoteDataSource.searchProducts(
          query: query,
          page: page,
          limit: limit,
        );
        return Right(remoteData);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheSearchData(SearchData searchData) async {
    try {
      await localDataSource.cacheSearchData(searchData as SearchDataModel);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, SearchData?>> getCachedSearchData() async {
    try {
      final cachedData = await localDataSource.getCachedSearchData();
      return Right(cachedData);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }
}
