import '../../../../../core/constants/storage_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/recently_viewed_ad_model.dart';

abstract class RecentlyViewedLocalDataSource {
  Future<List<RecentlyViewedAdModel>> getCachedRecentlyViewedAds();
  Future<void> cacheRecentlyViewedAds(List<RecentlyViewedAdModel> ads);
  Future<void> clearCache();
}

class RecentlyViewedLocalDataSourceImpl
    implements RecentlyViewedLocalDataSource {
  static const String _cacheKey = 'recently_viewed_ads_cache';

  @override
  Future<List<RecentlyViewedAdModel>> getCachedRecentlyViewedAds() async {
    try {
      final cacheData = StorageService.getCacheIfValid(_cacheKey);
      if (cacheData != null && cacheData['ads'] != null) {
        final List<dynamic> adsJson = cacheData['ads'];
        return adsJson
            .map((json) => RecentlyViewedAdModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException(
        'Failed to get cached recently viewed ads: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheRecentlyViewedAds(List<RecentlyViewedAdModel> ads) async {
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
      throw CacheException(
        'Failed to cache recently viewed ads: ${e.toString()}',
      );
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
