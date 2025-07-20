import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/coupons_data.dart';
import '../../domain/repositories/coupons_repository.dart';
import '../datasources/coupons_remote_datasource.dart';

class CouponsRepositoryImpl implements CouponsRepository {
  final CouponsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CouponsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CouponsData>> getCoupons({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteData = await remoteDataSource.getCoupons(
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
  Future<Either<Failure, bool>> applyCoupon({required String couponId}) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.applyCoupon(couponId: couponId);
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
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }
}
