import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/product_overview_repository.dart';

class AddToCart implements UseCase<bool, AddToCartParams> {
  final ProductOverviewRepository repository;

  AddToCart(this.repository);

  @override
  Future<Either<Failure, bool>> call(AddToCartParams params) async {
    return await repository.addToCart(
      productId: params.productId,
      sizeId: params.sizeId,
    );
  }
}

class AddToCartParams {
  final String productId;
  final String sizeId;

  const AddToCartParams({required this.productId, required this.sizeId});
}
