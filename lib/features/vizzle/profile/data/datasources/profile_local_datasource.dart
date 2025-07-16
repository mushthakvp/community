import '../../../../../core/constants/storage_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _cacheKey = 'profile_cache';

  @override
  Future<ProfileModel?> getCachedProfile() async {
    try {
      final cacheData = StorageService.getCacheIfValid(_cacheKey);
      if (cacheData != null && cacheData['profile'] != null) {
        return ProfileModel.fromJson(cacheData['profile']);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached profile: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    try {
      final cacheData = {
        'profile': profile.toJson(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await StorageService.setCacheWithExpiry(
        _cacheKey,
        cacheData,
        expiry: const Duration(hours: StorageConstants.shortCacheDuration),
      );
    } catch (e) {
      throw CacheException('Failed to cache profile: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_cacheKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
