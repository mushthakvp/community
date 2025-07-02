import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/services/cloudinary_service.dart';
import '../models/ad_creation_model.dart';
import '../models/category_model.dart';
import '../models/city_model.dart';

abstract class PlaceAddRemoteDataSource {
  Future<List<CityModel>> getCities();
  Future<List<CategoryModel>> getCategories();
  Future<List<String>> uploadImages(List<XFile> images);
  Future<AdCreationResponseModel> createAd(AdCreationRequestModel request);
  Future<String> getPlaceNameFromCoordinates(double latitude, double longitude);
}

class PlaceAddRemoteDataSourceImpl implements PlaceAddRemoteDataSource {
  final ApiClient apiClient;

  PlaceAddRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CityModel>> getCities() async {
    try {
      final response = await apiClient.get('user/getCities');
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final cities = data['cities'] as List<dynamic>;
        return cities
            .map((city) => CityModel.fromString(city.toString()))
            .toList();
      } else {
        throw ServerException(data['message'] ?? 'Failed to get cities');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get cities: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Use the correct endpoint for categories
      final response = await apiClient.get('user/getCategories');
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final categories = data['categories'] as List<dynamic>;
        return categories
            .map((category) => CategoryModel.fromJson(category))
            .toList();
      } else {
        // If categories endpoint doesn't work, try getCities which might have categories too
        final fallbackResponse = await apiClient.get('user/getCities');
        final fallbackData = jsonDecode(fallbackResponse.body);

        if (fallbackData['success'] == true &&
            fallbackData['categories'] != null) {
          final categories = fallbackData['categories'] as List<dynamic>;
          return categories
              .map((category) => CategoryModel.fromJson(category))
              .toList();
        } else {
          throw ServerException(data['message'] ?? 'Failed to get categories');
        }
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get categories: $e');
    }
  }

  @override
  Future<List<String>> uploadImages(List<XFile> images) async {
    try {
      List<String> urls = [];
      try {
        urls = await CloudinaryService.uploadImagesList(
          folder: 'vivera_ads',
          files: images.map((xfile) => File(xfile.path)).toList(),
        );
      } catch (e) {
        throw ServerException('Failed to upload image');
      }
      return urls;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to upload images: $e');
    }
  }

  @override
  Future<AdCreationResponseModel> createAd(
    AdCreationRequestModel request,
  ) async {
    try {
      final response = await apiClient.post(
        'user/createAd',
        body: request.toJson(),
      );

      final data = jsonDecode(response.body);
      return AdCreationResponseModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create ad: $e');
    }
  }

  @override
  Future<String> getPlaceNameFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await apiClient.get(
        'geocoding/reverse',
        queryParameters: {
          'lat': latitude.toString(),
          'lng': longitude.toString(),
        },
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['placeName'] ?? 'Unknown location';
      } else {
        throw ServerException(data['message'] ?? 'Failed to get place name');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get place name: $e');
    }
  }
}
