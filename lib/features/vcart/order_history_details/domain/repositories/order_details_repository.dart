import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/order_details.dart';
import '../entities/review.dart';

abstract class OrderDetailsRepository {
  Future<Either<Failure, OrderDetails>> getOrderDetails(String orderId);
  Future<Either<Failure, bool>> submitReview(OrderReview review);
}
