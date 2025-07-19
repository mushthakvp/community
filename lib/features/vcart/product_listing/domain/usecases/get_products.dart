import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/product_filter_params.dart';
import '../entities/product_listing_data.dart';
import '../repositories/product_listing_repository.dart';

class GetProducts implements UseCase<ProductListingData, ProductFilterParams> {
  final ProductListingRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, ProductListingData>> call(
    ProductFilterParams params,
  ) async {
    return await repository.getProducts(params);
  }
}
