import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/product_detail_repository.dart';

class ShareProductUseCase implements UseCase<String, String> {
  final ProductDetailRepository repository;

  ShareProductUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String productId) async {
    return await repository.shareProduct(productId);
  }
}
