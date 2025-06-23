// lib/features/coupons/data/repositories/coupon_repository_impl.dart

import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../datasources/coupon_local_datasource.dart';
import '../datasources/coupon_remote_datasource.dart';
import '../models/coupon_model.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponRemoteDataSource remoteDataSource;
  final CouponLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CouponRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, GetCouponsModel>> getCoupons({
    String? categoryId,
    String? appId,
    String? search,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteCoupons = await remoteDataSource.getCoupons(
          categoryId: categoryId,
          appId: appId,
          search: search,
        );

        // Cache the result
        await localDataSource.cacheCoupons(remoteCoupons);
        return Right(remoteCoupons);
      } else {
        // Try to get cached data when offline
        try {
          final cachedCoupons = await localDataSource.getCachedCoupons();
          return Right(cachedCoupons);
        } on CacheException {
          return const Left(
            NetworkFailure(
              'No internet connection and no cached data available',
            ),
          );
        }
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getCoupons: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getCoupons: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      dev.log('Cache exception in getCoupons: ${e.message}');
      return Left(CacheFailure(e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getCoupons',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        UnknownFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> actionOnCoupon(
    String couponId,
    String action, [
    String? reason,
  ]) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      if (couponId.isEmpty || action.isEmpty) {
        return const Left(ValidationFailure('Invalid coupon ID or action'));
      }

      if (action == 'dislike' && (reason == null || reason.trim().isEmpty)) {
        return const Left(
          ValidationFailure('Reason is required for dislike action'),
        );
      }

      final result = await remoteDataSource.actionOnCoupon(
        couponId,
        action,
        reason,
      );
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in actionOnCoupon: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in actionOnCoupon: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      dev.log('Validation exception in actionOnCoupon: ${e.message}');
      return Left(ValidationFailure(e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in actionOnCoupon',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        UnknownFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> useCoupon(String couponId) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure('No internet connection'));
      }

      if (couponId.isEmpty) {
        return const Left(ValidationFailure('Invalid coupon ID'));
      }

      final result = await remoteDataSource.useCoupon(couponId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in useCoupon: ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in useCoupon: ${e.message}');
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      dev.log('Validation exception in useCoupon: ${e.message}');
      return Left(ValidationFailure(e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in useCoupon',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        UnknownFailure('An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}
