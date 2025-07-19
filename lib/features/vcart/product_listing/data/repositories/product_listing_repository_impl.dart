import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/product_filter_params.dart';
import '../../domain/entities/product_listing_data.dart';
import '../../domain/repositories/product_listing_repository.dart';
import '../datasources/product_listing_remote_datasource.dart';

class ProductListingRepositoryImpl implements ProductListingRepository {
  final ProductListingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductListingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductListingData>> getProducts(
    ProductFilterParams params,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteData = await remoteDataSource.getProducts(params);
        return Right(remoteData);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, int>> getFilteredProductCount(
    ProductFilterParams params,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final count = await remoteDataSource.getFilteredProductCount(params);
        return Right(count);
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
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }
}
