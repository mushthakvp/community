import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/vcart_constants.dart';
import '../models/search_data_model.dart';

abstract class SearchLocalDataSource {
  Future<SearchDataModel?> getCachedSearchData();
  Future<void> cacheSearchData(SearchDataModel searchData);
  Future<void> clearCache();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const String _searchDataKey =
      '${VCartConstants.cacheKeyPrefix}search_data';
  static const String _timestampKey =
      '${VCartConstants.cacheKeyPrefix}search_timestamp';

  @override
  Future<SearchDataModel?> getCachedSearchData() async {
    try {
      final timestampString = StorageService.getString(_timestampKey);
      if (timestampString == null) return null;

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      if (now.difference(timestamp) > VCartConstants.cacheValidDuration) {
        await clearCache();
        return null;
      }

      final cachedData = StorageService.getString(_searchDataKey);
      if (cachedData == null) return null;

      final jsonData = json.decode(cachedData);
      return SearchDataModel.fromJson(jsonData);
    } catch (e) {
      throw CacheException('Failed to get cached search data: $e');
    }
  }

  @override
  Future<void> cacheSearchData(SearchDataModel searchData) async {
    try {
      final jsonString = json.encode(searchData.toJson());
      await StorageService.setString(_searchDataKey, jsonString);
      await StorageService.setString(
        _timestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache search data: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_searchDataKey);
      await StorageService.remove(_timestampKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
