import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/cart_data.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CartData>> getCartData() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteData = await remoteDataSource.getCartData();
          await localDataSource.cacheCartData(remoteData);
          return Right(remoteData);
        } catch (e) {
          // If remote fails, try to get cached data
          final cachedData = await localDataSource.getCachedCartData();
          if (cachedData != null) {
            return Right(cachedData);
          } else {
            return Left(_handleException(e));
          }
        }
      } else {
        final cachedData = await localDataSource.getCachedCartData();
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
  Future<Either<Failure, CartData>> updateItemQuantity({
    required String productId,
    required String sizeId,
    required String action,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final updatedCart = await remoteDataSource.updateItemQuantity(
          productId: productId,
          sizeId: sizeId,
          action: action,
        );
        await localDataSource.cacheCartData(updatedCart);
        return Right(updatedCart);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> moveToWishlist({
    required String productId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.moveToWishlist(
          productId: productId,
        );

        // Clear cart cache to force refresh on next get
        await localDataSource.clearCartCache();

        return Right(result);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, CartData>> applyCoupon({
    required String couponId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final updatedCart = await remoteDataSource.applyCoupon(
          couponId: couponId,
        );
        await localDataSource.cacheCartData(updatedCart);
        return Right(updatedCart);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, CartData>> removeCoupon() async {
    try {
      if (await networkInfo.isConnected) {
        final updatedCart = await remoteDataSource.removeCoupon();
        await localDataSource.cacheCartData(updatedCart);
        return Right(updatedCart);
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
