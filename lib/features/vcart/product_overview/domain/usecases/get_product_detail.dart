import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/product_overview_data.dart';
import '../repositories/product_overview_repository.dart';

class GetProductDetail
    implements UseCase<ProductOverviewData, GetProductDetailParams> {
  final ProductOverviewRepository repository;

  GetProductDetail(this.repository);

  @override
  Future<Either<Failure, ProductOverviewData>> call(
    GetProductDetailParams params,
  ) async {
    return await repository.getProductDetail(params.productId);
  }
}

class GetProductDetailParams {
  final String productId;

  const GetProductDetailParams({required this.productId});
}
