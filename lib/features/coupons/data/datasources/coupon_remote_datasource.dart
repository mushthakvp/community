// lib/features/coupons/data/datasources/coupon_remote_datasource.dart

import 'dart:convert';
import 'dart:developer' as dev;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/coupon_model.dart';

abstract class CouponRemoteDataSource {
  Future<GetCouponsModel> getCoupons({
    String? categoryId,
    String? appId,
    String? search,
  });

  Future<bool> actionOnCoupon(String couponId, String action, String? reason);
  Future<bool> useCoupon(String couponId);
}

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  final ApiClient apiClient;

  CouponRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<GetCouponsModel> getCoupons({
    String? categoryId,
    String? appId,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }
      if (appId != null && appId.isNotEmpty) {
        queryParams['appId'] = appId;
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await apiClient.get(
        ApiEndpoints.getCoupons,
        queryParameters: queryParams,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        return GetCouponsModel.fromJson(data);
      } else {
        throw ServerException('Failed to load coupons: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('Error in getCoupons remote datasource', error: e);
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred while fetching coupons');
    }
  }

  @override
  Future<bool> actionOnCoupon(
    String couponId,
    String action,
    String? reason,
  ) async {
    try {
      final data = <String, dynamic>{'action': action};
      if (reason != null && reason.isNotEmpty) {
        data['reason'] = reason;
      }

      final response = await apiClient.put(
        '${ApiEndpoints.actionOnCoupons}$couponId',
        body: json.encode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(errorData['message'] ?? 'Action failed');
      }
    } catch (e) {
      dev.log('Error in actionOnCoupon remote datasource', error: e);
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred while performing action');
    }
  }

  @override
  Future<bool> useCoupon(String couponId) async {
    try {
      final response = await apiClient.put(
        '${ApiEndpoints.useCoupon}$couponId',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(errorData['message'] ?? 'Failed to use coupon');
      }
    } catch (e) {
      dev.log('Error in useCoupon remote datasource', error: e);
      if (e is ServerException) rethrow;
      throw NetworkException('Network error occurred while using coupon');
    }
  }
}
