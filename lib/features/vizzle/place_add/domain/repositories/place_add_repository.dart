import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/failures.dart';
import '../entities/ad_creation.dart';
import '../entities/category.dart';
import '../entities/city.dart';

abstract class PlaceAddRepository {
  Future<Either<Failure, List<City>>> getCities();
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<String>>> uploadImages(List<XFile> images);
  Future<Either<Failure, AdCreationResponse>> createAd(
    AdCreationRequest request,
  );
  Future<Either<Failure, String>> getPlaceNameFromCoordinates(
    double latitude,
    double longitude,
  );
}
