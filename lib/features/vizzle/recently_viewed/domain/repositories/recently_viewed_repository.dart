import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/recently_viewed_ad_entity.dart';

abstract class RecentlyViewedRepository {
  Future<Either<Failure, List<RecentlyViewedAdEntity>>> getRecentlyViewedAds();
  Future<Either<Failure, void>> toggleFavorite(String adId);
  Future<Either<Failure, void>> clearRecentlyViewed();
  Future<Either<Failure, void>> clearCache();
}
