import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/ad_entity.dart';
import '../entities/ads_filter_entity.dart';
import '../entities/ads_response_entity.dart';

abstract class AdsRepository {
  Future<Either<Failure, AdsResponseEntity>> getAds({
    required int page,
    required int limit,
    AdsFilterEntity? filter,
  });

  Future<Either<Failure, AdEntity>> getAdById(String adId);

  Future<Either<Failure, bool>> toggleFavorite(String adId);

  Future<Either<Failure, List<AdEntity>>> getFavoriteAds();

  Future<Either<Failure, List<AdEntity>>> getRecentlyViewedAds();

  Future<Either<Failure, bool>> addToRecentlyViewed(String adId);

  Future<Either<Failure, List<String>>> getLocations();

  Future<Either<Failure, Map<String, List<String>>>> getFilterOptions();
}
