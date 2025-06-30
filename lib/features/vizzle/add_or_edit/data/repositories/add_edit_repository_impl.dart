import 'dart:io';

import 'package:geocoding/geocoding.dart';

import '../../../../../core/error/error_handler.dart';
import '../../../../../core/utils/result.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/add_edit_repository.dart';
import '../datasources/add_edit_remote_datasource.dart';
import '../models/ad_creation_model.dart';
import '../models/cities_response_model.dart';

class AddEditRepositoryImpl implements AddEditRepository {
  final AddEditRemoteDataSource remoteDataSource;

  AddEditRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<CitiesResponseModel>> getCitiesAndCategories() async {
    try {
      final result = await remoteDataSource.getCitiesAndCategories();
      return Success(result);
    } catch (e) {
      return Error(
        message: ErrorHandler.handleException(e as Exception).message,
      );
    }
  }

  @override
  Future<Result<List<String>>> uploadImages(List<File> images) async {
    try {
      final result = await remoteDataSource.uploadImages(images);
      return Success(result);
    } catch (e) {
      return Error(
        message: ErrorHandler.handleException(e as Exception).message,
      );
    }
  }

  @override
  Future<Result<String>> createAd(AdCreationModel adModel) async {
    try {
      final result = await remoteDataSource.createAd(adModel);
      return Success(result);
    } catch (e) {
      return Error(
        message: ErrorHandler.handleException(e as Exception).message,
      );
    }
  }

  @override
  Future<Result<String>> updateAd(String adId, AdCreationModel adModel) async {
    try {
      final result = await remoteDataSource.updateAd(adId, adModel);
      return Success(result);
    } catch (e) {
      return Error(
        message: ErrorHandler.handleException(e as Exception).message,
      );
    }
  }

  @override
  Future<Result<LocationEntity>> getLocationFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return Success(
          LocationEntity(
            latitude: latitude,
            longitude: longitude,
            placeName: place.locality ?? "Unknown Location",
            address: "${place.street}, ${place.locality}, ${place.country}",
          ),
        );
      }

      return const Error(message: "Could not determine location");
    } catch (e) {
      return Error(message: e.toString());
    }
  }
}
