import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/category_model.dart';
import '../models/section_model.dart';
import '../models/subcategory_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<SectionModel>> getSections({int page = 1, int limit = 1000});

  Future<List<CategoryItemModel>> getCategoriesBySection({
    required String sectionId,
    int page = 1,
    int limit = 1000,
  });

  Future<List<SubCategoryModel>> getSubCategoriesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 10,
  });
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final ApiClient apiClient;

  CategoriesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SectionModel>> getSections({
    int page = 1,
    int limit = 1000,
  }) async {
    try {
      final url = '${VCartEndpoints.sections}?limit=$limit&page=$page';
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sectionsResponse = SectionsResponseModel.fromJson(data);
        return sectionsResponse.sections;
      } else {
        throw ServerException('Failed to fetch sections');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<List<CategoryItemModel>> getCategoriesBySection({
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
        final categoriesResponse = CategoriesResponseModel.fromJson(data);
        return categoriesResponse.categories;
      } else {
        throw ServerException('Failed to fetch categories');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<List<SubCategoryModel>> getSubCategoriesByCategory({
    required String categoryId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url =
          '${VCartEndpoints.subCategories(categoryId)}&page=$page&limit=$limit';
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final subCategoriesResponse = SubCategoriesResponseModel.fromJson(data);
        return subCategoriesResponse.subCategories;
      } else {
        throw ServerException('Failed to fetch subcategories');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }
}
