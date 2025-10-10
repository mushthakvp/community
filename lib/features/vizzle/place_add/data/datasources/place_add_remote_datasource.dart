import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/network/network_info.dart';
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
  final NetworkInfo networkInfo;

  PlaceAddRemoteDataSourceImpl({
    required this.apiClient,
    required this.networkInfo,
  });

  @override
  Future<List<CityModel>> getCities() async {
    try {
      debugPrint('getCities called');
      final response = await ApiClient.main(networkInfo: networkInfo).get('user/getCities');
      debugPrint('getCities response status: ${response.statusCode}');
      debugPrint('getCities response body: ${response.body}');

      // Check if response is successful
      if (response.statusCode != 200) {
        throw ServerException('Server returned ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      debugPrint('getCities parsed data: $data');

      if (data['success'] == true) {
        final citiesData = data['cities'];

        // Handle if cities is null or not a list
        if (citiesData == null) {
          debugPrint('getCities: cities data is null');
          return [];
        }

        if (citiesData is! List) {
          debugPrint(
            'getCities: cities data is not a list, type: ${citiesData.runtimeType}',
          );
          throw ServerException('Invalid cities data format');
        }

        final cities = citiesData;
        debugPrint('getCities: Found ${cities.length} cities');

        return cities
            .map((city) {
              try {
                // Handle both string and object formats
                if (city is String) {
                  return CityModel.fromString(city);
                } else if (city is Map<String, dynamic>) {
                  return CityModel.fromJson(city);
                } else {
                  return CityModel.fromString(city.toString());
                }
              } catch (e) {
                debugPrint('Error parsing city: $city, error: $e');
                return null;
              }
            })
            .whereType<CityModel>() // Filter out nulls
            .toList();
      } else {
        final errorMessage = data['message'] ?? 'Failed to get cities';
        debugPrint('getCities error: $errorMessage');
        throw ServerException(errorMessage);
      }
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('getCities exception: $e');
      debugPrint('Stack trace: $stackTrace');
      throw ServerException('Failed to get cities: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      debugPrint('getCategories called');
      // FIXED: Changed endpoint from 'user/getCities' to proper categories endpoint
      final response = await ApiClient.main(networkInfo: networkInfo).get('user/getCities');
      debugPrint('getCategories response: ${response.body}');

      if (response.statusCode != 200) {
        throw ServerException('Server returned ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final categoriesData = data['categories'];

        if (categoriesData == null || categoriesData is! List) {
          throw ServerException('Invalid categories data format');
        }

        final categories = categoriesData;
        return categories
            .map((category) {
              try {
                return CategoryModel.fromJson(category);
              } catch (e) {
                debugPrint('Error parsing category: $category, error: $e');
                return null;
              }
            })
            .whereType<CategoryModel>()
            .toList();
      } else {
        throw ServerException(data['message'] ?? 'Failed to get categories');
      }
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('getCategories exception: $e');
      debugPrint('Stack trace: $stackTrace');
      throw ServerException('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> uploadImages(List<XFile> images) async {
    try {
      List<String> uploadedUrls = await CloudinaryService.uploadImagesList(
        folder: 'upload/image',
        files: images.map((image) => File(image.path)).toList(),
      );
      return uploadedUrls;
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
      final response = await ApiClient.main(networkInfo: networkInfo).post(
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
      final response = await ApiClient.main(networkInfo: networkInfo).get(
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
