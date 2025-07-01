import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/vizzle_entities.dart';
import '../repositories/vizzle_repository.dart';

class ManageFavoritesUseCase {
  final VizzleRepository repository;

  ManageFavoritesUseCase(this.repository);

  Future<Either<Failure, bool>> addToFavorites(String adId) async {
    if (adId.isEmpty) {
      return const Left(ValidationFailure(message: 'Ad ID cannot be empty'));
    }
    return await repository.addToFavorites(adId);
  }

  Future<Either<Failure, bool>> removeFromFavorites(String adId) async {
    if (adId.isEmpty) {
      return const Left(ValidationFailure(message: 'Ad ID cannot be empty'));
    }
    return await repository.removeFromFavorites(adId);
  }

  Future<Either<Failure, List<AdEntity>>> getFavorites() async {
    return await repository.getFavoriteAds();
  }
}
