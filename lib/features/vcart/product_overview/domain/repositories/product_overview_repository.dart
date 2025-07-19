import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/product_overview_data.dart';
import '../entities/review.dart';

abstract class ProductOverviewRepository {
  Future<Either<Failure, ProductOverviewData>> getProductDetail(
    String productId,
  );
  Future<Either<Failure, List<Review>>> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, bool>> addToCart({
    required String productId,
    required String sizeId,
  });
  Future<Either<Failure, bool>> toggleWishlist(String productId);
}
