import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/seller_profile_model.dart';

abstract class SellerRemoteDataSource {
  Future<SellerProfileModel> getSellerProfile(String sellerId);
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  final ApiClient apiClient;

  SellerRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SellerProfileModel> getSellerProfile(String sellerId) async {
    try {
      final response = await apiClient.get(
        'user/getProfile',
        queryParameters: {'userId': sellerId},
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return SellerProfileModel.fromJson(data['user']);
      } else {
        throw ServerException(
          data['message'] ?? 'Failed to get seller profile',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get seller profile: $e');
    }
  }
}
