import 'dart:convert';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<void> deleteAd(String adId);
  Future<void> markAsSold(String adId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.profile);
      final data = jsonDecode(response.body);

      if (data['success'] == true || response.statusCode == 200) {
        return ProfileModel.fromJson(data);
      } else {
        throw ServerException(data['message'] ?? 'Failed to fetch profile');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAd(String adId) async {
    try {
      final response = await apiClient.delete('${ApiConstants.deleteAd}/$adId');
      final data = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerException(data['message'] ?? 'Failed to delete ad');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }

  @override
  Future<void> markAsSold(String adId) async {
    try {
      final response = await apiClient.put(
        '${ApiConstants.deleteAd}/$adId?status=sold',
      );
      final data = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerException(data['message'] ?? 'Failed to mark as sold');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: ${e.toString()}');
    }
  }
}
