import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/section_category_data_model.dart';

abstract class SectionCategoryRemoteDataSource {
  Future<SectionCategoryDataModel> getCategoriesBySection({
    required String sectionId,
    int page = 1,
    int limit = 1000,
  });
}

class SectionCategoryRemoteDataSourceImpl
    implements SectionCategoryRemoteDataSource {
  final ApiClient apiClient;

  SectionCategoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SectionCategoryDataModel> getCategoriesBySection({
    required String sectionId,
    int page = 1,
    int limit = 1000,
  }) async {
    try {
      final url =
          '${VCartEndpoints.categories}?sectionId=$sectionId&limit=$limit&page=$page';
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SectionCategoryDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch categories by section');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }
}
