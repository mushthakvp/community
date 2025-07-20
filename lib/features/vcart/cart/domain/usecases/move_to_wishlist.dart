import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

class MoveToWishlist implements UseCase<bool, MoveToWishlistParams> {
  final CartRepository repository;

  MoveToWishlist(this.repository);

  @override
  Future<Either<Failure, bool>> call(MoveToWishlistParams params) async {
    return await repository.moveToWishlist(productId: params.productId);
  }
}

class MoveToWishlistParams {
  final String productId;

  const MoveToWishlistParams({required this.productId});
}
