import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/ad_entity.dart';
import '../repositories/ads_repository.dart';

class ManageRecentlyViewedUseCase {
  final AdsRepository repository;

  ManageRecentlyViewedUseCase(this.repository);

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
