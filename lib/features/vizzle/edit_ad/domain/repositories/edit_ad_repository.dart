import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../profile/domain/entities/advertisement_entity.dart';
import '../entities/edit_ad_request_entity.dart';
import '../entities/edit_ad_response_entity.dart';

abstract class EditAdRepository {
  Future<Either<Failure, AdvertisementEntity>> getAdDetails(String adId);
  Future<Either<Failure, EditAdResponseEntity>> editAd(
    EditAdRequestEntity request,
  );
  Future<Either<Failure, List<String>>> uploadImages(List<String> imagePaths);
}
