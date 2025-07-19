import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/profile_data_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileDataModel> getProfileData();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileDataModel> getProfileData() async {
    try {
      final response = await apiClient.get(VCartEndpoints.getProfile);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProfileDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch profile data');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }
}
