import 'dart:io';

import '../../../../../core/utils/result.dart';
import '../../data/models/ad_creation_model.dart';
import '../../data/models/cities_response_model.dart';
import '../entities/location_entity.dart';

abstract class AddEditRepository {
  Future<Result<CitiesResponseModel>> getCitiesAndCategories();
  Future<Result<List<String>>> uploadImages(List<File> images);
  Future<Result<String>> createAd(AdCreationModel adModel);
  Future<Result<String>> updateAd(String adId, AdCreationModel adModel);
  Future<Result<LocationEntity>> getLocationFromCoordinates(
    double latitude,
    double longitude,
  );
}
