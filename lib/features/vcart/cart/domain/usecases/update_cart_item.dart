import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/cart_data.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItem implements UseCase<CartData, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  @override
  Future<Either<Failure, CartData>> call(UpdateCartItemParams params) async {
    return await repository.updateItemQuantity(
      productId: params.productId,
      sizeId: params.sizeId,
      action: params.action,
    );
  }
}

class UpdateCartItemParams {
  final String productId;
  final String sizeId;
  final String action;

  const UpdateCartItemParams({
    required this.productId,
    required this.sizeId,
    required this.action,
  });
}
