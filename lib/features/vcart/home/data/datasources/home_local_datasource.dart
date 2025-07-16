import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/vcart_constants.dart';
import '../models/home_data_model.dart';

abstract class HomeLocalDataSource {
  Future<HomeDataModel?> getCachedHomeData();
  Future<void> cacheHomeData(HomeDataModel homeData);
  Future<void> clearCache();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const String _homeDataKey =
      '${VCartConstants.cacheKeyPrefix}home_data';
  static const String _timestampKey =
      '${VCartConstants.cacheKeyPrefix}home_data_timestamp';

  @override
  Future<HomeDataModel?> getCachedHomeData() async {
    try {
      final timestampString = StorageService.getString(_timestampKey);
      if (timestampString == null) return null;

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      if (now.difference(timestamp) > VCartConstants.cacheValidDuration) {
        await clearCache();
        return null;
      }

      final cachedData = StorageService.getString(_homeDataKey);
      if (cachedData == null) return null;

      final jsonData = json.decode(cachedData);
      return HomeDataModel.fromJson(jsonData);
    } catch (e) {
      throw CacheException('Failed to get cached home data: $e');
    }
  }

  @override
  Future<void> cacheHomeData(HomeDataModel homeData) async {
    try {
      final jsonString = json.encode(homeData.toJson());
      await StorageService.setString(_homeDataKey, jsonString);
      await StorageService.setString(
        _timestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache home data: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_homeDataKey);
      await StorageService.remove(_timestampKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
