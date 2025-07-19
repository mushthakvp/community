import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../../domain/entities/product_filter_params.dart';
import '../models/product_listing_data_model.dart';

abstract class ProductListingRemoteDataSource {
  Future<ProductListingDataModel> getProducts(ProductFilterParams params);
  Future<int> getFilteredProductCount(ProductFilterParams params);
}

class ProductListingRemoteDataSourceImpl
    implements ProductListingRemoteDataSource {
  final ApiClient apiClient;

  ProductListingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProductListingDataModel> getProducts(
    ProductFilterParams params,
  ) async {
    try {
      final url = _buildProductUrl(params);
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProductListingDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch products');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<int> getFilteredProductCount(ProductFilterParams params) async {
    try {
      final url = _buildFilterCountUrl(params);
      final response = await apiClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      } else {
        throw ServerException('Failed to fetch product count');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }

  String _buildProductUrl(ProductFilterParams params) {
    final queryParams = <String, String>{
      'page': params.page.toString(),
      'limit': params.limit.toString(),
      'sort': params.sortBy,
    };

    if (params.sectionId != null) queryParams['section'] = params.sectionId!;
    if (params.categoryId != null) queryParams['category'] = params.categoryId!;
    if (params.subCategoryId != null) {
      queryParams['subCategory'] = params.subCategoryId!;
    }
    if (params.brandId != null) queryParams['brand'] = params.brandId!;
    if (params.minPrice != null) {
      queryParams['filterStartPrice'] = params.minPrice!.toString();
    }
    if (params.maxPrice != null) {
      queryParams['filterEndPrice'] = params.maxPrice!.toString();
    }
    if (params.colors.isNotEmpty) {
      queryParams['color'] = Uri.encodeComponent(params.colors.join(','));
    }
    if (params.sizes.isNotEmpty) {
      queryParams['size'] = Uri.encodeComponent(params.sizes.join(','));
    }
    if (params.offers.isNotEmpty) {
      queryParams['offer'] = Uri.encodeComponent(params.offers.join(','));
    }

    final uri = Uri.parse(
      VCartEndpoints.productData,
    ).replace(queryParameters: queryParams);
    return uri.toString();
  }

  String _buildFilterCountUrl(ProductFilterParams params) {
    final queryParams = <String, String>{
      'page': params.page.toString(),
      'limit': params.limit.toString(),
      'sort': params.sortBy,
    };

    if (params.sectionId != null) queryParams['section'] = params.sectionId!;
    if (params.categoryId != null) queryParams['category'] = params.categoryId!;
    if (params.subCategoryId != null) {
      queryParams['subCategory'] = params.subCategoryId!;
    }
    if (params.brandId != null) queryParams['brand'] = params.brandId!;
    if (params.minPrice != null) {
      queryParams['filterStartPrice'] = params.minPrice!.toString();
    }
    if (params.maxPrice != null) {
      queryParams['filterEndPrice'] = params.maxPrice!.toString();
    }
    if (params.colors.isNotEmpty) {
      queryParams['color'] = Uri.encodeComponent(params.colors.join(','));
    }
    if (params.sizes.isNotEmpty) {
      queryParams['size'] = Uri.encodeComponent(params.sizes.join(','));
    }
    if (params.offers.isNotEmpty) {
      queryParams['offer'] = Uri.encodeComponent(params.offers.join(','));
    }

    final uri = Uri.parse(
      VCartEndpoints.filterProductData,
    ).replace(queryParameters: queryParams);
    return uri.toString();
  }
}
