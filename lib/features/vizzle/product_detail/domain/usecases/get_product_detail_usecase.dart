import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/product_detail.dart';
import '../repositories/product_detail_repository.dart';

class GetProductDetailUseCase implements UseCase<ProductDetail, String> {
  final ProductDetailRepository repository;

  GetProductDetailUseCase(this.repository);

  @override
  Future<Either<Failure, ProductDetail>> call(String shareUrl) async {
    return await repository.getProductDetail(shareUrl);
  }
}
