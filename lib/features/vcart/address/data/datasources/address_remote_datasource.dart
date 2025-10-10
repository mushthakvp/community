import 'dart:convert';
import 'dart:developer';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../../core/constants/vcart_endpoints.dart';
import '../models/address_list_response_model.dart';
import '../models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<AddressListResponseModel> getAddresses({int page = 1, int limit = 10});
  Future<AddressModel> addAddress(Map<String, dynamic> addressData);
  Future<AddressModel> updateAddress({
    required String id,
    required Map<String, dynamic> addressData,
  });
  Future<bool> deleteAddress(String id);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiClient apiClient;

  AddressRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AddressListResponseModel> getAddresses({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        '${VCartEndpoints.getAddress}?page=$page&limit=$limit',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AddressListResponseModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch addresses');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<AddressModel> addAddress(Map<String, dynamic> addressData) async {
    try {
      log('Adding address with data: $addressData');
      final response = await apiClient.post(
        VCartEndpoints.addAddress,
        body: addressData,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = json.decode(response.body);
        return AddressModel.fromJson(data['address'] ?? data);
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(errorData['message'] ?? 'Failed to add address');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<AddressModel> updateAddress({
    required String id,
    required Map<String, dynamic> addressData,
  }) async {
    try {
      final data = {...addressData, 'id': id};
      final response = await apiClient.post(
        VCartEndpoints.updateAddress,
        body: data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return AddressModel.fromJson(responseData['address'] ?? responseData);
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Failed to update address',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<bool> deleteAddress(String id) async {
    try {
      final data = {'id': id};
      final response = await apiClient.post(
        VCartEndpoints.deleteAddress,
        body: data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Failed to delete address',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
