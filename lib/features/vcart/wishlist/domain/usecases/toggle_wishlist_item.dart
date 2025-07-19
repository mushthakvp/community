import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

class ToggleWishlistItem implements UseCase<bool, ToggleWishlistParams> {
  final WishlistRepository repository;

  ToggleWishlistItem(this.repository);

  @override
  Future<Either<Failure, bool>> call(ToggleWishlistParams params) async {
    return await repository.toggleWishlistItem(params.productId);
  }
}

class ToggleWishlistParams {
  final String productId;

  const ToggleWishlistParams({required this.productId});
}
