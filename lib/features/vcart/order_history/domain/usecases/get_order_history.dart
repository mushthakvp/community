import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/order_history.dart';
import '../repositories/order_history_repository.dart';

class GetOrderHistory implements UseCase<OrderHistory, GetOrderHistoryParams> {
  final OrderHistoryRepository repository;

  GetOrderHistory(this.repository);

  @override
  Future<Either<Failure, OrderHistory>> call(
    GetOrderHistoryParams params,
  ) async {
    return await repository.getOrderHistory(
      page: params.page,
      limit: params.limit,
      year: params.year,
    );
  }
}

class GetOrderHistoryParams {
  final int page;
  final int limit;
  final String? year;

  const GetOrderHistoryParams({this.page = 1, this.limit = 10, this.year});
}
