import '../../../../../core/constants/storage_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/saved_ad_model.dart';

abstract class SavedAdsLocalDataSource {
  Future<List<SavedAdModel>> getCachedSavedAds();
  Future<void> cacheSavedAds(List<SavedAdModel> ads);
  Future<void> clearCache();
}

class SavedAdsLocalDataSourceImpl implements SavedAdsLocalDataSource {
  static const String _cacheKey = 'saved_ads_cache';

  @override
  Future<List<SavedAdModel>> getCachedSavedAds() async {
    try {
      final cacheData = StorageService.getCacheIfValid(_cacheKey);
      if (cacheData != null && cacheData['ads'] != null) {
        final List<dynamic> adsJson = cacheData['ads'];
        return adsJson.map((json) => SavedAdModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached saved ads: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheSavedAds(List<SavedAdModel> ads) async {
    try {
      final cacheData = {
        'ads': ads.map((ad) => ad.toJson()).toList(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await StorageService.setCacheWithExpiry(
        _cacheKey,
        cacheData,
        expiry: const Duration(hours: StorageConstants.shortCacheDuration),
      );
    } catch (e) {
      throw CacheException('Failed to cache saved ads: ${e.toString()}');
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
