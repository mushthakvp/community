import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/search_data_model.dart';
import '../models/search_results_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchDataModel> getSearchData();
  Future<SearchResultsModel> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SearchDataModel> getSearchData() async {
    try {
      final url = '${VCartEndpoints.searchData}?limit=10&page=1';
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SearchDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch search data');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<SearchResultsModel> searchProducts({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url =
          '${VCartEndpoints.productData}?page=$page&limit=$limit&search=$query';
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SearchResultsModel.fromJson(data);
      } else {
        throw ServerException('Failed to search products');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }
}
