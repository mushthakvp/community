import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/vizzle_entities.dart';
import '../repositories/vizzle_repository.dart';

class RecentlyViewedUseCase {
  final VizzleRepository repository;

  RecentlyViewedUseCase(this.repository);

  Future<Either<Failure, List<AdEntity>>> getRecentlyViewed() async {
    return await repository.getRecentlyViewedAds();
  }

  Future<Either<Failure, bool>> addToRecentlyViewed(String adId) async {
    if (adId.isEmpty) {
      return const Left(ValidationFailure(message: 'Ad ID cannot be empty'));
    }
    return await repository.addToRecentlyViewed(adId);
  }
}
