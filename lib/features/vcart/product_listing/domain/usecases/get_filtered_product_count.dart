import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/product_filter_params.dart';
import '../repositories/product_listing_repository.dart';

class GetFilteredProductCount implements UseCase<int, ProductFilterParams> {
  final ProductListingRepository repository;

  GetFilteredProductCount(this.repository);

  @override
  Future<Either<Failure, int>> call(ProductFilterParams params) async {
    return await repository.getFilteredProductCount(params);
  }
}
