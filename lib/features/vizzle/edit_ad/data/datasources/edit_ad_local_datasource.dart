import '../../../../../core/constants/storage_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../profile/data/models/advertisement_model.dart';

abstract class EditAdLocalDataSource {
  Future<AdvertisementModel?> getCachedAdDetails(String adId);
  Future<void> cacheAdDetails(String adId, AdvertisementModel ad);
  Future<void> clearCache(String adId);
}

class EditAdLocalDataSourceImpl implements EditAdLocalDataSource {
  static const String _cachePrefix = 'edit_ad_cache_';

  @override
  Future<AdvertisementModel?> getCachedAdDetails(String adId) async {
    try {
      final cacheKey = '$_cachePrefix$adId';
      final cacheData = StorageService.getCacheIfValid(cacheKey);
      if (cacheData != null && cacheData['ad'] != null) {
        return AdvertisementModel.fromJson(cacheData['ad']);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached ad details: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheAdDetails(String adId, AdvertisementModel ad) async {
    try {
      final cacheKey = '$_cachePrefix$adId';
      final cacheData = {
        'ad': ad.toJson(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await StorageService.setCacheWithExpiry(
        cacheKey,
        cacheData,
        expiry: const Duration(hours: StorageConstants.shortCacheDuration),
      );
    } catch (e) {
      throw CacheException('Failed to cache ad details: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache(String adId) async {
    try {
      final cacheKey = '$_cachePrefix$adId';
      await StorageService.remove(cacheKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
