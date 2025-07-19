import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/product_overview_repository.dart';

class ToggleWishlist implements UseCase<bool, ToggleWishlistParams> {
  final ProductOverviewRepository repository;

  ToggleWishlist(this.repository);

  @override
  Future<Either<Failure, bool>> call(ToggleWishlistParams params) async {
    return await repository.toggleWishlist(params.productId);
  }
}

class ToggleWishlistParams {
  final String productId;

  const ToggleWishlistParams({required this.productId});
}
