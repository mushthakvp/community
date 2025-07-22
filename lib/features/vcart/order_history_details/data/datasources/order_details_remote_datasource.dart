import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../../domain/entities/review.dart';
import '../models/order_details_model.dart';

abstract class OrderDetailsRemoteDataSource {
  Future<OrderDetailsModel> getOrderDetails(String orderId);
  Future<bool> submitReview(OrderReview review);
}

class OrderDetailsRemoteDataSourceImpl implements OrderDetailsRemoteDataSource {
  final ApiClient apiClient;

  OrderDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderDetailsModel> getOrderDetails(String orderId) async {
    try {
      final response = await apiClient.get(
        VCartEndpoints.orderDetails(orderId),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return OrderDetailsModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch order details');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<bool> submitReview(OrderReview review) async {
    try {
      final data = {
        'orderId': review.orderId,
        'rating': review.rating,
        'review': review.review,
        'images': review.images,
      };

      final response = await apiClient.post(
        VCartEndpoints.addReview,
        body: data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        throw ServerException('Failed to submit review');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
