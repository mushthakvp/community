import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/order_history.dart';
import '../../domain/repositories/order_history_repository.dart';
import '../datasources/order_history_remote_datasource.dart';

class OrderHistoryRepositoryImpl implements OrderHistoryRepository {
  final OrderHistoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderHistoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderHistory>> getOrderHistory({
    int page = 1,
    int limit = 10,
    String? year,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final orderHistory = await remoteDataSource.getOrderHistory(
          page: page,
          limit: limit,
          year: year,
        );
        return Right(orderHistory);
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
