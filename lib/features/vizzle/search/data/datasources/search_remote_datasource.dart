import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResultModel> searchAds(String keyword);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SearchResultModel> searchAds(String keyword) async {
    try {
      final response = await apiClient.get(
        'user/searchAll',
        queryParameters: {'keyword': keyword},
      );

      final data = jsonDecode(response.body);
      return SearchResultModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to search ads: $e');
    }
  }
}
