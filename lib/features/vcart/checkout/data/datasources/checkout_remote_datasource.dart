import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../address/data/models/address_model.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/order_result_model.dart';
import '../models/razorpay_config_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<List<AddressModel>> getAddresses({int page = 1, int limit = 10});
  Future<RazorpayConfigModel> initiateRazorpayPayment({
    required String addressId,
  });
  Future<OrderResultModel> initiateWalletPayment({required String addressId});
  Future<OrderResultModel> verifyRazorpayPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  });
  Future<double> getWalletBalance();
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final ApiClient apiClient;

  CheckoutRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AddressModel>> getAddresses({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        '${VCartEndpoints.getAddress}?page=$page&limit=$limit',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addressList = (data['shippingAddress'] as List)
            .map((item) => AddressModel.fromJson(item))
            .toList();
        return addressList;
      } else {
        throw ServerException('Failed to fetch addresses');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<RazorpayConfigModel> initiateRazorpayPayment({
    required String addressId,
  }) async {
    try {
      final data = {'shippingAddress': addressId};
      final response = await apiClient.post(
        VCartEndpoints.initiateCheckout('razorPay'),
        body: data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return RazorpayConfigModel.fromJson(responseData);
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Failed to initiate payment',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<OrderResultModel> initiateWalletPayment({
    required String addressId,
  }) async {
    try {
      final data = {'shippingAddress': addressId};
      final response = await apiClient.post(
        VCartEndpoints.initiateCheckout('wallet'),
        body: data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return OrderResultModel.fromJson(responseData, isSuccess: true);
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Failed to process wallet payment',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<OrderResultModel> verifyRazorpayPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final response = await apiClient.get(
        '${VCartEndpoints.verifyPayment}?razorPay_order_id=$orderId&razorPay_payment_id=$paymentId&razorPay_signature=$signature',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return OrderResultModel.fromJson(responseData, isSuccess: true);
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Payment verification failed',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<double> getWalletBalance() async {
    try {
      final response = await apiClient.get(VCartEndpoints.getProfile);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['walletAmount'] ?? 0.0).toDouble();
      } else {
        throw ServerException('Failed to fetch wallet balance');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
