import 'dart:convert';
import 'dart:developer' as dev;

import 'package:livera/core/constants/api_constants.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../domain/entities/ads_filter_entity.dart';
import '../models/ad_model.dart';
import '../models/ads_response_model.dart';

abstract class AdsRemoteDataSource {
  Future<AdsResponseModel> getAds({
    required int page,
    required int limit,
    AdsFilterEntity? filter,
  });

  Future<AdModel> getAdById(String adId);

  Future<bool> toggleFavorite(String adId);

  Future<List<AdModel>> getFavoriteAds();

  Future<List<String>> getLocations();

  Future<Map<String, List<String>>> getFilterOptions();
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final ApiClient apiClient;

  AdsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AdsResponseModel> getAds({
    required int page,
    required int limit,
    AdsFilterEntity? filter,
  }) async {
    try {
      final queryParams = _buildQueryParams(page, limit, filter);
      dev.log(
        'Making request to ${ApiConstants.vizzleAds} with params: $queryParams',
      );

      final response = await ApiClient.main().get(
        ApiConstants.vizzleAds,
        queryParameters: queryParams,
      );
      dev.log('Ads Response Status: ${response.statusCode}');
      final responseData = json.decode(response.body);
      dev.log('Ads Response Data: $responseData');

      return AdsResponseModel.fromJson(responseData);
    } catch (e) {
      dev.log('Error getting ads: $e');
      throw const ServerException('Failed to get ads');
    }
  }

  @override
  Future<AdModel> getAdById(String adId) async {
    try {
      final response = await ApiClient.main().get(
        '${ApiConstants.vizzleAds}/$adId',
      );
      final responseData = json.decode(response.body);

      return AdModel.fromJson(responseData['ad'] ?? responseData);
    } catch (e) {
      dev.log('Error getting ad by id: $e');
      throw const ServerException('Failed to get ad details');
    }
  }

  @override
  Future<bool> toggleFavorite(String adId) async {
    try {
      final response = await ApiClient.main().post(
        '${ApiConstants.vizzleAddToFavorite}/$adId',
      );
      final responseData = json.decode(response.body);

      return responseData['success'] ?? false;
    } catch (e) {
      dev.log('Error toggling favorite: $e');
      throw const ServerException('Failed to toggle favorite');
    }
  }

  @override
  Future<List<AdModel>> getFavoriteAds() async {
    try {
      final response = await ApiClient.main().get(ApiConstants.vizzleSavedAds);
      final responseData = json.decode(response.body);

      final adsData = responseData['ads'] ?? [];
      return (adsData as List)
          .map((adJson) => AdModel.fromJson(adJson))
          .toList();
    } catch (e) {
      dev.log('Error getting favorite ads: $e');
      throw const ServerException('Failed to get favorite ads');
    }
  }

  @override
  Future<List<String>> getLocations() async {
    try {
      final response = await ApiClient.main().get('user/getLocations');
      final responseData = json.decode(response.body);

      final locations = responseData['locations'] ?? [];
      return List<String>.from(locations);
    } catch (e) {
      dev.log('Error getting locations: $e');
      throw const ServerException('Failed to get locations');
    }
  }

  @override
  Future<Map<String, List<String>>> getFilterOptions() async {
    try {
      final response = await ApiClient.main().get('user/getFilterOptions');
      final responseData = json.decode(response.body);

      return Map<String, List<String>>.from(
        responseData['filterOptions']?.map(
              (key, value) => MapEntry(key, List<String>.from(value)),
            ) ??
            {},
      );
    } catch (e) {
      dev.log('Error getting filter options: $e');
      throw const ServerException('Failed to get filter options');
    }
  }

  Map<String, String> _buildQueryParams(
    int page,
    int limit,
    AdsFilterEntity? filter,
  ) {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (filter != null) {
      // Category filters - Use the correct parameter names as per your working endpoint
      if (filter.categoryId != null) {
        params['category'] =
            filter.categoryId!; // Changed from 'categoryId' to 'category'
      }
      if (filter.subCategoryId != null) {
        params['subCategory'] = filter
            .subCategoryId!; // Changed from 'subCategoryId' to 'subCategory'
      }

      // Location filter
      if (filter.location != null) {
        params['city'] = filter.location!; // Changed from 'location' to 'city'
      }

      // Price filters
      if (filter.minPrice != null) {
        params['minPrice'] = filter.minPrice!.toString();
      }
      if (filter.maxPrice != null) {
        params['maxPrice'] = filter.maxPrice!.toString();
      }

      // Search keyword
      if (filter.keyword != null && filter.keyword!.isNotEmpty) {
        params['keyword'] = filter.keyword!;
      }

      // Sort parameter
      params['sort'] = _getSortParam(filter.sortBy);

      // Vehicle-specific filters
      if (filter.vehicleFilter != null) {
        final vehicleFilter = filter.vehicleFilter!;
        if (vehicleFilter.brands.isNotEmpty) {
          params['brands'] = vehicleFilter.brands.join(',');
        }
        if (vehicleFilter.minYear != null) {
          params['year'] = vehicleFilter.minYear!
              .toString(); // Using year instead of minYear/maxYear
        }
        if (vehicleFilter.minKilometers != null) {
          params['minKilometers'] = vehicleFilter.minKilometers!.toString();
        }
        if (vehicleFilter.maxKilometers != null) {
          params['maxKilometers'] = vehicleFilter.maxKilometers!.toString();
        }
        if (vehicleFilter.fuelTypes.isNotEmpty) {
          params['fuelType'] =
              vehicleFilter.fuelTypes.first; // Using single fuelType
        }
        if (vehicleFilter.transmissions.isNotEmpty) {
          params['transmissionType'] =
              vehicleFilter.transmissions.first; // Using transmissionType
        }
        if (vehicleFilter.colors.isNotEmpty) {
          params['color'] = vehicleFilter.colors.first; // Using single color
        }
      }

      // Property-specific filters
      if (filter.propertyFilter != null) {
        final propertyFilter = filter.propertyFilter!;
        if (propertyFilter.propertyTypes.isNotEmpty) {
          params['propertyTypes'] = propertyFilter.propertyTypes.join(',');
        }
        if (propertyFilter.minBedrooms != null) {
          params['minBedrooms'] = propertyFilter.minBedrooms!.toString();
        }
        if (propertyFilter.maxBedrooms != null) {
          params['maxBedrooms'] = propertyFilter.maxBedrooms!.toString();
        }
        if (propertyFilter.minBathrooms != null) {
          params['minBathrooms'] = propertyFilter.minBathrooms!.toString();
        }
        if (propertyFilter.maxBathrooms != null) {
          params['maxBathrooms'] = propertyFilter.maxBathrooms!.toString();
        }
        if (propertyFilter.minArea != null) {
          params['minArea'] = propertyFilter.minArea!.toString();
        }
        if (propertyFilter.maxArea != null) {
          params['maxArea'] = propertyFilter.maxArea!.toString();
        }
      }

      // Amenities
      if (filter.amenities.isNotEmpty) {
        params['amenities'] = filter.amenities.join(',');
      }

      // Add default empty values for parameters that should be present
      params.putIfAbsent('adsPostedWithin', () => '');
    }

    return params;
  }

  String _getSortParam(AdsFilterSort sortBy) {
    switch (sortBy) {
      case AdsFilterSort.newest:
        return 'newest';
      case AdsFilterSort.oldest:
        return 'oldest';
      case AdsFilterSort.priceLowToHigh:
        return 'price_asc';
      case AdsFilterSort.priceHighToLow:
        return 'price_desc';
      case AdsFilterSort.featured:
        return 'featured';
    }
  }
}
