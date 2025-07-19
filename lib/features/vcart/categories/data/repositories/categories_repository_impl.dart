import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/section.dart';
import '../../domain/entities/subcategory.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_local_datasource.dart';
import '../datasources/categories_remote_datasource.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;
  final CategoriesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Section>>> getSections({
    int page = 1,
    int limit = 1000,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteData = await remoteDataSource.getSections(
            page: page,
            limit: limit,
          );
          await localDataSource.cacheSections(remoteData);
          return Right(remoteData);
        } catch (e) {
          final cachedData = await localDataSource.getCachedSections();
          if (cachedData != null) {
            return Right(cachedData);
          } else {
            return Left(_handleException(e));
          }
        }
      } else {
        final cachedData = await localDataSource.getCachedSections();
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
  Future<Either<Failure, List<CategoryItem>>> getCategoriesBySection({
    required String sectionId,
    int page = 1,
    int limit = 1000,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteData = await remoteDataSource.getCategoriesBySection(
            sectionId: sectionId,
            page: page,
            limit: limit,
          );
          await localDataSource.cacheCategories(sectionId, remoteData);
          return Right(remoteData);
        } catch (e) {
          final cachedData = await localDataSource.getCachedCategories(
            sectionId,
          );
          if (cachedData != null) {
            return Right(cachedData);
          } else {
            return Left(_handleException(e));
          }
        }
      } else {
        final cachedData = await localDataSource.getCachedCategories(sectionId);
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
  Future<Either<Failure, List<SubCategory>>> getSubCategoriesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteData = await remoteDataSource.getSubCategoriesByCategory(
          categoryId: categoryId,
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
