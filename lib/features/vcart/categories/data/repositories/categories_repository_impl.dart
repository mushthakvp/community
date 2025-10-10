import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/section.dart';
import '../../domain/entities/subcategory.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_datasource.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoriesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Section>>> getSections({
    int page = 1,
    int limit = 1000,
  }) async {
    try {
      try {
        final remoteData = await remoteDataSource.getSections(
          page: page,
          limit: limit,
        );
        return Right(remoteData);
      } catch (e) {
        return Left(_handleException(e));
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
      try {
        final remoteData = await remoteDataSource.getCategoriesBySection(
          sectionId: sectionId,
          page: page,
          limit: limit,
        );
        return Right(remoteData);
      } catch (e) {
        return Left(_handleException(e));
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
