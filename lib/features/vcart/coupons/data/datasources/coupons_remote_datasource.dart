import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/coupons_data_model.dart';

abstract class CouponsRemoteDataSource {
  Future<CouponsDataModel> getCoupons({int page = 1, int limit = 10});
  Future<bool> applyCoupon({required String couponId});
}

class CouponsRemoteDataSourceImpl implements CouponsRemoteDataSource {
  final ApiClient apiClient;

  CouponsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CouponsDataModel> getCoupons({int page = 1, int limit = 10}) async {
    try {
      final response = await apiClient.get(
        '${VCartEndpoints.getCoupons}?page=$page&limit=$limit',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CouponsDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch coupons');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<bool> applyCoupon({required String couponId}) async {
    try {
      final data = {"couponId": couponId};
      final response = await apiClient.post(
        VCartEndpoints.applyCoupon,
        body: data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(errorData['message'] ?? 'Failed to apply coupon');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
