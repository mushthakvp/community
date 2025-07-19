import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/product_overview_response_model.dart';
import '../models/review_model.dart';
import '../models/reviews_response_model.dart';

abstract class ProductOverviewRemoteDataSource {
  Future<ProductOverviewResponseModel> getProductDetail(String productId);
  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
  });
  Future<bool> addToCart({required String productId, required String sizeId});
  Future<bool> toggleWishlist(String productId);
}

class ProductOverviewRemoteDataSourceImpl
    implements ProductOverviewRemoteDataSource {
  final ApiClient apiClient;

  ProductOverviewRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProductOverviewResponseModel> getProductDetail(
    String productId,
  ) async {
    try {
      final url = VCartEndpoints.productDetail(productId);
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProductOverviewResponseModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch product details');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url =
          '${VCartEndpoints.productReviews(productId)}&limit=$limit&page=$page';
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reviewsResponse = ReviewsResponseModel.fromJson(data);
        return reviewsResponse.reviews;
      } else {
        throw ServerException('Failed to fetch product reviews');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<bool> addToCart({
    required String productId,
    required String sizeId,
  }) async {
    try {
      final data = {"productId": productId, "sizeId": sizeId};
      final response = await apiClient.post(
        VCartEndpoints.addToCart,
        body: data,
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(errorData['message'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<bool> toggleWishlist(String productId) async {
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
