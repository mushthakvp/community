import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/filter_data_model.dart';

abstract class FilterPageRemoteDataSource {
  Future<FilterDataModel> getFilterData({String? sectionId, String? brandId});
}

class FilterPageRemoteDataSourceImpl implements FilterPageRemoteDataSource {
  final ApiClient apiClient;

  FilterPageRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<FilterDataModel> getFilterData({
    String? sectionId,
    String? brandId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (sectionId != null) queryParams['section'] = sectionId;
      if (brandId != null) queryParams['brand'] = brandId;

      final uri = Uri.parse(
        VCartEndpoints.filterPageData(''),
      ).replace(queryParameters: queryParams);
      final response = await apiClient.get(uri.toString());

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return FilterDataModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch filter data');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error: $e');
    }
  }
}
