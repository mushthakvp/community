import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/order_history_model.dart';

abstract class OrderHistoryRemoteDataSource {
  Future<OrderHistoryModel> getOrderHistory({
    int page = 1,
    int limit = 10,
    String? year,
  });
}

class OrderHistoryRemoteDataSourceImpl implements OrderHistoryRemoteDataSource {
  final ApiClient apiClient;

  OrderHistoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderHistoryModel> getOrderHistory({
    int page = 1,
    int limit = 10,
    String? year,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (year != null && year.isNotEmpty) 'year': year,
      };
      final response = await apiClient.get(
        '${VCartEndpoints.orderHistory}?${Uri(queryParameters: queryParams).query}',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return OrderHistoryModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch order history');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
