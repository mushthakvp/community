import 'dart:convert';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/saved_ad_model.dart';

abstract class SavedAdsRemoteDataSource {
  Future<List<SavedAdModel>> getSavedAds();
  Future<void> toggleFavorite(String adId);
}

class SavedAdsRemoteDataSourceImpl implements SavedAdsRemoteDataSource {
  final ApiClient apiClient;

  SavedAdsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SavedAdModel>> getSavedAds() async {
    try {
      final response = await apiClient.get(ApiConstants.vizzleSavedAds);
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final List<dynamic> adsJson = data['ads'] ?? [];
        return adsJson.map((json) => SavedAdModel.fromJson(json)).toList();
      } else {
        throw ServerException(data['message'] ?? 'Failed to fetch saved ads');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleFavorite(String adId) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.vizzleAddToFavorite}/$adId',
      );
      final data = jsonDecode(response.body);
      if (data['success'] != true) {
        throw ServerException(data['message'] ?? 'Failed to toggle favorite');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
