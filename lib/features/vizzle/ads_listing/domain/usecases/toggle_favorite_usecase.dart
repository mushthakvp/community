import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/ads_repository.dart';

class ToggleFavoriteUseCase implements UseCase<bool, String> {
  final AdsRepository repository;

  ToggleFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String adId) async {
    if (adId.isEmpty) {
      return const Left(ValidationFailure(message: 'Ad ID cannot be empty'));
    }

    return await repository.toggleFavorite(adId);
  }
}
