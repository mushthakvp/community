import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../address/domain/entities/address.dart';
import '../../domain/entities/order_result.dart';
import '../../domain/entities/razorpay_config.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CheckoutRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Address>>> getAddresses({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final addresses = await remoteDataSource.getAddresses(
          page: page,
          limit: limit,
        );
        return Right(addresses.cast<Address>());
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, RazorpayConfig>> initiateRazorpayPayment({
    required String addressId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final config = await remoteDataSource.initiateRazorpayPayment(
          addressId: addressId,
        );
        return Right(config);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, OrderResult>> initiateWalletPayment({
    required String addressId,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.initiateWalletPayment(
          addressId: addressId,
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
  Future<Either<Failure, OrderResult>> verifyRazorpayPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.verifyRazorpayPayment(
          orderId: orderId,
          paymentId: paymentId,
          signature: signature,
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
  Future<Either<Failure, double>> getWalletBalance() async {
    try {
      if (await networkInfo.isConnected) {
        final balance = await remoteDataSource.getWalletBalance();
        return Right(balance);
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
