import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/order_details_repository.dart';

class SubmitReview implements UseCase<bool, OrderReview> {
  final OrderDetailsRepository repository;

  SubmitReview(this.repository);

  @override
  Future<Either<Failure, bool>> call(OrderReview review) async {
    return await repository.submitReview(review);
  }
}
