import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/wishlist_data_model.dart';

abstract class WishlistRemoteDataSource {
  Future<WishlistDataModel> getWishlistData({int page = 1, int limit = 10});
  Future<bool> toggleWishlistItem(String productId);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiClient apiClient;

  WishlistRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<WishlistDataModel> getWishlistData({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url = '${VCartEndpoints.getWishList}?page=$page&limit=$limit';
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WishlistDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch wishlist data');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<bool> toggleWishlistItem(String productId) async {
    try {
      final data = {"productId": productId};
      final response = await apiClient.post(
        VCartEndpoints.wishListAction,
        body: data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Failed to update wishlist',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }
}
