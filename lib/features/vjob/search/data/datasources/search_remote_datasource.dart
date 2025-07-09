import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/recent_search_model.dart';
import '../models/search_jobs_model.dart';

abstract class SearchRemoteDataSource {
  Future<RecentSearchesResponseModel> getRecentSearches();
  Future<SearchJobsResponseModel> searchJobs({
    required String query,
    int page = 1,
    int limit = 10,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<RecentSearchesResponseModel> getRecentSearches() async {
    try {
      final response = await apiClient.get('user/get-recent-search-jobs');
      final data = json.decode(response.body);
      return RecentSearchesResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SearchJobsResponseModel> searchJobs({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        'user/get-search-jobs',
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
          'search': query,
        },
      );
      final data = json.decode(response.body);
      return SearchJobsResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
