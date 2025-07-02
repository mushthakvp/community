import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/product_detail_model.dart';

abstract class ProductDetailRemoteDataSource {
  Future<ProductDetailModel> getProductDetail(String shareUrl);
  Future<bool> toggleFavorite(String productId);
  Future<String> shareProduct(String productId);
  Future<bool> reportProduct(String productId, String reason);
  Future<String> accessChat(String friendId, String postId);
}

class ProductDetailRemoteDataSourceImpl
    implements ProductDetailRemoteDataSource {
  final ApiClient apiClient;

  ProductDetailRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProductDetailModel> getProductDetail(String shareUrl) async {
    try {
      final response = await apiClient.get(shareUrl);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return ProductDetailModel.fromJson(data);
      } else {
        throw ServerException(
          data['message'] ?? 'Failed to get product details',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get product details: $e');
    }
  }

  @override
  Future<bool> toggleFavorite(String productId) async {
    try {
      final response = await apiClient.post('user/saveFeed/$productId');
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw ServerException(data['message'] ?? 'Failed to toggle favorite');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to toggle favorite: $e');
    }
  }

  @override
  Future<String> shareProduct(String productId) async {
    try {
      final response = await apiClient.post('user/shareFeed/$productId');
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data['shareLink'] ?? '';
      } else {
        throw ServerException(data['message'] ?? 'Failed to share product');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to share product: $e');
    }
  }

  @override
  Future<bool> reportProduct(String productId, String reason) async {
    try {
      final response = await apiClient.post(
        'user/reportPost',
        body: {
          'postId': productId,
          'postType': 'advertisement',
          'reason': reason,
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        throw ServerException(data['message'] ?? 'Failed to report product');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to report product: $e');
    }
  }

  @override
  Future<String> accessChat(String friendId, String postId) async {
    try {
      final response = await apiClient.get(
        'user/accessChat',
        queryParameters: {'friendId': friendId, 'postId': postId},
      );
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data['chat']['_id'] ?? '';
      } else {
        throw ServerException(data['message'] ?? 'Failed to access chat');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to access chat: $e');
    }
  }
}
