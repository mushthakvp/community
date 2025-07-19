import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/product_overview_data.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/product_overview_repository.dart';
import '../datasources/product_overview_local_datasource.dart';
import '../datasources/product_overview_remote_datasource.dart';

class ProductOverviewRepositoryImpl implements ProductOverviewRepository {
  final ProductOverviewRemoteDataSource remoteDataSource;
  final ProductOverviewLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductOverviewRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductOverviewData>> getProductDetail(
    String productId,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteData = await remoteDataSource.getProductDetail(productId);
          await localDataSource.cacheProductDetail(productId, remoteData);
          return Right(remoteData);
        } catch (e) {
          final cachedData = await localDataSource.getCachedProductDetail(
            productId,
          );
          if (cachedData != null) {
            return Right(cachedData);
          } else {
            return Left(_handleException(e));
          }
        }
      } else {
        final cachedData = await localDataSource.getCachedProductDetail(
          productId,
        );
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
  Future<Either<Failure, List<Review>>> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteData = await remoteDataSource.getProductReviews(
          productId: productId,
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
  Future<Either<Failure, bool>> addToCart({
    required String productId,
    required String sizeId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.addToCart(
          productId: productId,
          sizeId: sizeId,
        );
        return Right(result);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleWishlist(String productId) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.toggleWishlist(productId);
        return Right(result);
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
