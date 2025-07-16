import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _profileCacheKey = 'cached_profile';

  @override
  Future<ProfileModel?> getCachedProfile() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_profileCacheKey);
      if (cachedData != null) {
        return ProfileModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached profile: $e');
    }
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    try {
      await StorageService.setCacheWithExpiry(
        _profileCacheKey,
        profile.toJson(),
        expiry: const Duration(hours: 1),
      );
    } catch (e) {
      throw CacheException('Failed to cache profile: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_profileCacheKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
