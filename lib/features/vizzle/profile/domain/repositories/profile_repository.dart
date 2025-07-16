import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, void>> deleteAd(String adId);
  Future<Either<Failure, void>> markAsSold(String adId);
  Future<Either<Failure, void>> clearCache();
}
