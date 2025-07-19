import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/product_filter_params.dart';
import '../entities/product_listing_data.dart';

abstract class ProductListingRepository {
  Future<Either<Failure, ProductListingData>> getProducts(
    ProductFilterParams params,
  );
  Future<Either<Failure, int>> getFilteredProductCount(
    ProductFilterParams params,
  );
}
