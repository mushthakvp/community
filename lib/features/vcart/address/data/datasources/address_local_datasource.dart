import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/vcart_constants.dart';
import '../models/address_model.dart';

abstract class AddressLocalDataSource {
  Future<AddressModel?> getCachedSelectedAddress();
  Future<void> cacheSelectedAddress(AddressModel address);
  Future<void> clearAddressCache();
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  static const String _selectedAddressKey =
      '${VCartConstants.cacheKeyPrefix}selected_address';

  @override
  Future<AddressModel?> getCachedSelectedAddress() async {
    try {
      final cachedData = StorageService.getString(_selectedAddressKey);
      if (cachedData == null) return null;

      final jsonData = json.decode(cachedData);
      return AddressModel.fromJson(jsonData);
    } catch (e) {
      throw CacheException('Failed to get cached selected address: $e');
    }
  }

  @override
  Future<void> cacheSelectedAddress(AddressModel address) async {
    try {
      final jsonString = json.encode(address.toJson());
      await StorageService.setString(_selectedAddressKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache selected address: $e');
    }
  }

  @override
  Future<void> clearAddressCache() async {
    try {
      await StorageService.remove(_selectedAddressKey);
    } catch (e) {
      throw CacheException('Failed to clear address cache: $e');
    }
  }
}
