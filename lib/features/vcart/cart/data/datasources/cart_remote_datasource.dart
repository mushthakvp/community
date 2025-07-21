import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/cart_data_model.dart';

abstract class CartRemoteDataSource {
  Future<CartDataModel> getCartData();
  Future<CartDataModel> updateItemQuantity({
    required String productId,
    required String sizeId,
    required String action,
  });
  Future<bool> moveToWishlist({required String productId});
  Future<CartDataModel> applyCoupon({required String couponId});
  Future<CartDataModel> removeCoupon();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CartDataModel> getCartData() async {
    try {
      final response = await apiClient.get(VCartEndpoints.getCart);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CartDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch cart data');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<CartDataModel> updateItemQuantity({
    required String productId,
    required String sizeId,
    required String action,
  }) async {
    try {
      final data = {"productId": productId, "sizeId": sizeId};
      final response = await apiClient.post(
        VCartEndpoints.cartAction(action),
        body: data,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return await getCartData();
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(errorData['message'] ?? 'Failed to update cart');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<bool> moveToWishlist({required String productId}) async {
    try {
      final data = {"productId": productId};
      final response = await apiClient.post(
        VCartEndpoints.moveToWishListFromCart,
        body: data,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Failed to move to wishlist',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<CartDataModel> applyCoupon({required String couponId}) async {
    try {
      final data = {"couponId": couponId};
      final response = await apiClient.post(
        VCartEndpoints.applyCoupon,
        body: data,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return await getCartData();
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(errorData['message'] ?? 'Failed to apply coupon');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<CartDataModel> removeCoupon() async {
    try {
      final response = await apiClient.post(
        VCartEndpoints.removeCoupon,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return await getCartData();
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Failed to remove coupon',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
