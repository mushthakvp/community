import 'package:dartz/dartz.dart';

import '../../../../../core/error/error_handler.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/repositories/product_detail_repository.dart';
import '../datasources/product_detail_remote_datasource.dart';

class ProductDetailRepositoryImpl implements ProductDetailRepository {
  final ProductDetailRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductDetailRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductDetail>> getProductDetail(
    String shareUrl,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getProductDetail(shareUrl);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String productId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.toggleFavorite(productId);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> shareProduct(String productId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.shareProduct(productId);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> reportProduct(
    String productId,
    String reason,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.reportProduct(productId, reason);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> accessChat(
    String friendId,
    String postId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.accessChat(friendId, postId);
        return Right(result);
      } catch (e) {
        return Left(ErrorHandler.handleException(e as Exception));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
