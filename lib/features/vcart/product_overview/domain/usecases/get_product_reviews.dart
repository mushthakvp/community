import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/product_overview_repository.dart';

class GetProductReviews
    implements UseCase<List<Review>, GetProductReviewsParams> {
  final ProductOverviewRepository repository;

  GetProductReviews(this.repository);

  @override
  Future<Either<Failure, List<Review>>> call(
    GetProductReviewsParams params,
  ) async {
    return await repository.getProductReviews(
      productId: params.productId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetProductReviewsParams {
  final String productId;
  final int page;
  final int limit;
  final bool isLoadMore;

  const GetProductReviewsParams({
    required this.productId,
    this.page = 1,
    this.limit = 10,
    this.isLoadMore = false,
  });
}
