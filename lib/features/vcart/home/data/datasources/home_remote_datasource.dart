import 'dart:convert';
import 'dart:developer';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/home_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<HomeDataModel> getHomeData() async {
    try {
      final response = await apiClient.get(VCartEndpoints.homeData);
      log('Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HomeDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch home data');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }
}
