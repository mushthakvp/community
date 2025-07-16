import 'dart:convert';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/recently_viewed_ad_model.dart';

abstract class RecentlyViewedRemoteDataSource {
  Future<List<RecentlyViewedAdModel>> getRecentlyViewedAds();
  Future<void> toggleFavorite(String adId);
  Future<void> clearRecentlyViewed();
}

class RecentlyViewedRemoteDataSourceImpl
    implements RecentlyViewedRemoteDataSource {
  final ApiClient apiClient;

  RecentlyViewedRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<RecentlyViewedAdModel>> getRecentlyViewedAds() async {
    try {
      final response = await apiClient.get(ApiConstants.vizzleRecentlyViewed);
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final List<dynamic> adsJson = data['ads'] ?? [];
        return adsJson
            .map((json) => RecentlyViewedAdModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
          data['message'] ?? 'Failed to fetch recently viewed ads',
        );
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

  @override
  Future<void> clearRecentlyViewed() async {
    try {
      final response = await apiClient.delete(
        '${ApiConstants.vizzleRecentlyViewed}/clear',
      );
      final data = jsonDecode(response.body);
      if (data['success'] != true) {
        throw ServerException(
          data['message'] ?? 'Failed to clear recently viewed',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
