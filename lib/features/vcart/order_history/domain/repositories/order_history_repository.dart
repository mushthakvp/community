import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/order_history.dart';

abstract class OrderHistoryRepository {
  Future<Either<Failure, OrderHistory>> getOrderHistory({
    int page = 1,
    int limit = 10,
    String? year,
  });
}
