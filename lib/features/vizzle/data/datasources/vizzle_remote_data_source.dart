import 'dart:convert';

import 'package:livera/core/constants/api_constants.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/vizzle_models.dart';

abstract class VizzleRemoteDataSource {
  Future<VizzleHomeModel> getVizzleHome();
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String categoryId);
  Future<List<SubCategoryModel>> getSubCategories(String categoryId);
  Future<SubCategoryModel> getSubCategoryById(String subCategoryId);
  Future<List<SubSubCategoryModel>> getSubSubCategories(String subCategoryId);
  Future<SubSubCategoryModel> getSubSubCategoryById(String subSubCategoryId);
  Future<List<SubItemModel>> getSubItems(String subSubCategoryId);
  Future<SubItemModel> getSubItemById(String subItemId);
  Future<List<AdModel>> getAds({
    String? categoryId,
    String? subCategoryId,
    String? subSubCategoryId,
    String? subItemId,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  });
  Future<AdModel> getAdById(String adId);
  Future<List<AdModel>> searchAds({
    required String keyword,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  });
  Future<bool> addToFavorites(String adId);
  Future<bool> removeFromFavorites(String adId);
  Future<List<AdModel>> getFavoriteAds();
}

class VizzleRemoteDataSourceImpl implements VizzleRemoteDataSource {
  final ApiClient apiClient;

  VizzleRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<VizzleHomeModel> getVizzleHome() async {
    try {
      final response = await ApiClient.main().get(ApiConstants.vizzleHome);
      final responseData = json.decode(response.body);
      return VizzleHomeModel.fromJson(responseData);
    } catch (e) {
      throw const ServerException('Failed to get vizzle home data');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await ApiClient.main().get('user/getCities');
      final responseData = json.decode(response.body);
      if (responseData['categories'] != null) {
        return (responseData['categories'] as List)
            .map((category) => CategoryModel.fromJson(category))
            .toList();
      }
      return [];
    } catch (e) {
      throw const ServerException('Failed to get categories');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      final response = await ApiClient.main().get('user/getCities/$categoryId');
      final responseData = json.decode(response.body);
      return CategoryModel.fromJson(responseData);
    } catch (e) {
      throw const ServerException('Failed to get category');
    }
  }

  @override
  Future<List<SubCategoryModel>> getSubCategories(String categoryId) async {
    try {
      final response = await ApiClient.main().get('user/getCities');
      final responseData = json.decode(response.body);
      if (responseData['categories'] != null) {
        final categories = (responseData['categories'] as List)
            .map((category) => CategoryModel.fromJson(category))
            .toList();
        final targetCategory = categories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () => CategoryModel(id: '', name: '', subcategories: []),
        );

        return targetCategory.subcategories;
      }
      return [];
    } catch (e) {
      throw const ServerException('Failed to get subcategories');
    }
  }

  @override
  Future<SubCategoryModel> getSubCategoryById(String subCategoryId) async {
    try {
      final response = await ApiClient.main().get(
        'user/getSubCategory/$subCategoryId',
      );
      final responseData = json.decode(response.body);
      return SubCategoryModel.fromJson(responseData);
    } catch (e) {
      throw const ServerException('Failed to get subcategory');
    }
  }

  @override
  Future<List<SubSubCategoryModel>> getSubSubCategories(
    String subCategoryId,
  ) async {
    try {
      final response = await ApiClient.main().get(
        'user/getSubSubCategories/$subCategoryId',
      );
      final responseData = json.decode(response.body);
      if (responseData['categories'] != null) {
        return (responseData['categories'] as List)
            .map(
              (subSubCategory) => SubSubCategoryModel.fromJson(subSubCategory),
            )
            .toList();
      }
      return [];
    } catch (e) {
      throw const ServerException('Failed to get sub-subcategories');
    }
  }

  @override
  Future<SubSubCategoryModel> getSubSubCategoryById(
    String subSubCategoryId,
  ) async {
    try {
      final response = await ApiClient.main().get(
        'user/getSubSubCategories/$subSubCategoryId',
      );
      final responseData = json.decode(response.body);
      return SubSubCategoryModel.fromJson(responseData);
    } catch (e) {
      throw const ServerException('Failed to get sub-subcategory');
    }
  }

  @override
  Future<List<SubItemModel>> getSubItems(String subSubCategoryId) async {
    try {
      final response = await ApiClient.main().get(
        '/user/getSubSubCategories/$subSubCategoryId',
      );
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        final categories = responseData['categories'] as List;
        final category = categories.firstWhere(
          (cat) => cat['_id'] == subSubCategoryId,
          orElse: () => null,
        );
        if (category != null && category['subItems'] != null) {
          final subItems = category['subItems'] as List;
          return subItems.map((item) => SubItemModel.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      throw ServerException('Failed to get sub items');
    }
  }

  @override
  Future<SubItemModel> getSubItemById(String subItemId) async {
    try {
      final response = await ApiClient.main().get('user/getSubItems/$subItemId');
      final responseData = json.decode(response.body);
      return SubItemModel.fromJson(responseData);
    } catch (e) {
      throw const ServerException('Failed to get sub item');
    }
  }

  @override
  Future<List<AdModel>> getAds({
    String? categoryId,
    String? subCategoryId,
    String? subSubCategoryId,
    String? subItemId,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  }) async {
    try {
      Map<String, String> queryParams = {};

      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (subCategoryId != null) queryParams['subCategoryId'] = subCategoryId;
      if (subSubCategoryId != null) {
        queryParams['subSubCategoryId'] = subSubCategoryId;
      }
      if (subItemId != null) queryParams['subItemId'] = subItemId;
      if (searchQuery != null) queryParams['searchQuery'] = searchQuery;
      if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final response = await apiClient.get(
        'user/getAds',
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (responseData['ads'] != null) {
        return (responseData['ads'] as List)
            .map((ad) => AdModel.fromJson(ad))
            .toList();
      }
      return [];
    } catch (e) {
      throw const ServerException('Failed to get ads');
    }
  }

  @override
  Future<AdModel> getAdById(String adId) async {
    try {
      final response = await ApiClient.main().get('user/getAds/$adId');
      final responseData = json.decode(response.body);
      return AdModel.fromJson(responseData);
    } catch (e) {
      throw const ServerException('Failed to get ad');
    }
  }

  @override
  Future<List<AdModel>> searchAds({
    required String keyword,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  }) async {
    try {
      Map<String, String> queryParams = {'keyword': keyword};

      if (categoryId != null) queryParams['categoryId'] = categoryId;
      if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();
      final response = await apiClient.get(
        'user/searchAll',
        queryParameters: queryParams,
      );
      final responseData = json.decode(response.body);
      if (responseData['ads'] != null) {
        return (responseData['ads'] as List)
            .map((ad) => AdModel.fromJson(ad))
            .toList();
      }
      return [];
    } catch (e) {
      throw const ServerException('Failed to search ads');
    }
  }

  @override
  Future<bool> addToFavorites(String adId) async {
    try {
      final response = await ApiClient.main().post(
        'user/saveFeed/$adId',
        body: {'adId': adId},
      );
      final responseData = json.decode(response.body);
      return responseData['success'] ?? false;
    } catch (e) {
      throw const ServerException('Failed to add to favorites');
    }
  }

  @override
  Future<bool> removeFromFavorites(String adId) async {
    try {
      final response = await ApiClient.main().delete('user/removeFeed/$adId');
      final responseData = json.decode(response.body);
      return responseData['success'] ?? false;
    } catch (e) {
      throw const ServerException('Failed to remove from favorites');
    }
  }

  @override
  Future<List<AdModel>> getFavoriteAds() async {
    try {
      final response = await ApiClient.main().get('user/savedAds');
      final responseData = json.decode(response.body);

      if (responseData['ads'] != null) {
        return (responseData['ads'] as List)
            .map((ad) => AdModel.fromJson(ad))
            .toList();
      }
      return [];
    } catch (e) {
      throw const ServerException('Failed to get favorite ads');
    }
  }
}
