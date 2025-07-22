import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/order_details_repository.dart';
import '../datasources/order_details_remote_datasource.dart';

class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  final OrderDetailsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderDetails>> getOrderDetails(String orderId) async {
    try {
      if (await networkInfo.isConnected) {
        final orderDetails = await remoteDataSource.getOrderDetails(orderId);
        return Right(orderDetails);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> submitReview(OrderReview review) async {
    try {
      if (await networkInfo.isConnected) {
        final success = await remoteDataSource.submitReview(review);
        return Right(success);
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
