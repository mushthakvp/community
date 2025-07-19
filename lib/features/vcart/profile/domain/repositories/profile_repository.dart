import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/profile_data.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileData>> getProfileData();
  Future<Either<Failure, void>> cacheProfileData(ProfileData profileData);
  Future<Either<Failure, ProfileData?>> getCachedProfileData();
}
