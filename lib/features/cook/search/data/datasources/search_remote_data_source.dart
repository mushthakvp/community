import '../../../../../core/error/exceptions.dart';
import '../../../core/constants/cook_api_endpoints.dart';
import '../../../core/network/cook_api_client.dart';
import '../../domain/entities/search_result.dart';
import '../models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResult> searchChallenges({
    required String query,
    int page = 1,
    int limit = 20,
  });

  Future<List<String>> getSearchSuggestions(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final CookApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SearchResult> searchChallenges({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, String>{
      'search': query,
      'currentPage': '1',
      'currentLimit': (limit ~/ 2).toString(),
      'upcomingPage': page.toString(),
      'upcomingLimit': (limit ~/ 2).toString(),
    };

    final result = await apiClient.get(
      CookApiEndpoints.getHome,
      queryParameters: params,
    );

    return result.fold(
      (failure) => throw ServerException(failure.message),
      (data) => SearchResultModel.fromJson(data, query),
    );
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    return [];
  }
}
