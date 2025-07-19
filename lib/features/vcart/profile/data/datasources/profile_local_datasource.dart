import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/vcart_constants.dart';
import '../models/profile_data_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileDataModel?> getCachedProfileData();
  Future<void> cacheProfileData(ProfileDataModel profileData);
  Future<void> clearCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _profileDataKey =
      '${VCartConstants.cacheKeyPrefix}profile_data';
  static const String _timestampKey =
      '${VCartConstants.cacheKeyPrefix}profile_timestamp';

  @override
  Future<ProfileDataModel?> getCachedProfileData() async {
    try {
      final timestampString = StorageService.getString(_timestampKey);
      if (timestampString == null) return null;

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      if (now.difference(timestamp) > VCartConstants.cacheValidDuration) {
        await clearCache();
        return null;
      }

      final cachedData = StorageService.getString(_profileDataKey);
      if (cachedData == null) return null;

      final jsonData = json.decode(cachedData);
      return ProfileDataModel.fromJson(jsonData);
    } catch (e) {
      throw CacheException('Failed to get cached profile data: $e');
    }
  }

  @override
  Future<void> cacheProfileData(ProfileDataModel profileData) async {
    try {
      final jsonString = json.encode(profileData.toJson());
      await StorageService.setString(_profileDataKey, jsonString);
      await StorageService.setString(
        _timestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache profile data: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_profileDataKey);
      await StorageService.remove(_timestampKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
