import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/order_details.dart';
import '../repositories/order_details_repository.dart';

class GetOrderDetails implements UseCase<OrderDetails, String> {
  final OrderDetailsRepository repository;

  GetOrderDetails(this.repository);

  @override
  Future<Either<Failure, OrderDetails>> call(String orderId) async {
    return await repository.getOrderDetails(orderId);
  }
}
