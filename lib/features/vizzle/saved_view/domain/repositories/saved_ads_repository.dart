import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/saved_ad_entity.dart';

abstract class SavedAdsRepository {
  Future<Either<Failure, List<SavedAdEntity>>> getSavedAds();
  Future<Either<Failure, void>> toggleFavorite(String adId);
  Future<Either<Failure, void>> clearCache();
}
