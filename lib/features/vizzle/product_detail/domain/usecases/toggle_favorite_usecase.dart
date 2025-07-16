import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/product_detail_repository.dart';

class ToggleFavoriteUseCase implements UseCase<bool, String> {
  final ProductDetailRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String productId) async {
    return await repository.toggleFavorite(productId);
  }
}
