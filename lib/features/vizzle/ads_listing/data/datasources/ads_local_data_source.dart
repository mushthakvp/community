import 'dart:developer' as dev;

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/ad_model.dart';

abstract class AdsLocalDataSource {
  Future<List<AdModel>> getCachedAds(String cacheKey);
  Future<void> cacheAds(String cacheKey, List<AdModel> ads);
  Future<AdModel?> getCachedAdById(String adId);
  Future<void> cacheAd(AdModel ad);
  Future<List<AdModel>> getFavoriteAds();
  Future<void> saveFavoriteAds(List<AdModel> ads);
  Future<List<AdModel>> getRecentlyViewedAds();
  Future<void> addToRecentlyViewed(AdModel ad);
  Future<void> clearCache();
}

class AdsLocalDataSourceImpl implements AdsLocalDataSource {
  static const String _adsCachePrefix = 'ads_cache_';
  static const String _adCachePrefix = 'ad_cache_';
  static const String _favoriteAdsCacheKey = 'favorite_ads_cache';
  static const String _recentlyViewedCacheKey = 'recently_viewed_ads_cache';
  static const int _maxRecentlyViewed = 50;
  static const Duration _cacheValidDuration = Duration(minutes: 15);

  @override
  Future<List<AdModel>> getCachedAds(String cacheKey) async {
    try {
      final cacheData = StorageService.getCacheIfValid(
        '$_adsCachePrefix$cacheKey',
      );
      if (cacheData != null) {
        final adsData = cacheData['ads'] as List;
        return adsData.map((adJson) => AdModel.fromJson(adJson)).toList();
      }
      throw const CacheException('No cached ads found');
    } catch (e) {
      dev.log('Error getting cached ads: $e');
      throw const CacheException('Failed to get cached ads');
    }
  }

  @override
  Future<void> cacheAds(String cacheKey, List<AdModel> ads) async {
    try {
      final cacheData = {
        'ads': ads.map((ad) => ad.toJson()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };

      await StorageService.setCacheWithExpiry(
        '$_adsCachePrefix$cacheKey',
        cacheData,
        expiry: _cacheValidDuration,
      );

      dev.log('Ads cached successfully for key: $cacheKey');
    } catch (e) {
      dev.log('Error caching ads: $e');
      throw const CacheException('Failed to cache ads');
    }
  }

  @override
  Future<AdModel?> getCachedAdById(String adId) async {
    try {
      final cacheData = StorageService.getCacheIfValid('$_adCachePrefix$adId');
      if (cacheData != null) {
        return AdModel.fromJson(cacheData);
      }
      return null;
    } catch (e) {
      dev.log('Error getting cached ad: $e');
      return null;
    }
  }

  @override
  Future<void> cacheAd(AdModel ad) async {
    try {
      await StorageService.setCacheWithExpiry(
        '$_adCachePrefix${ad.id}',
        ad.toJson(),
        expiry: _cacheValidDuration,
      );

      dev.log('Ad cached successfully: ${ad.id}');
    } catch (e) {
      dev.log('Error caching ad: $e');
      throw const CacheException('Failed to cache ad');
    }
  }

  @override
  Future<List<AdModel>> getFavoriteAds() async {
    try {
      final cacheData = StorageService.getCacheIfValid(_favoriteAdsCacheKey);
      if (cacheData != null) {
        final adsData = cacheData['ads'] as List;
        return adsData.map((adJson) => AdModel.fromJson(adJson)).toList();
      }
      return [];
    } catch (e) {
      dev.log('Error getting favorite ads: $e');
      return [];
    }
  }

  @override
  Future<void> saveFavoriteAds(List<AdModel> ads) async {
    try {
      final cacheData = {
        'ads': ads.map((ad) => ad.toJson()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await StorageService.setCacheWithExpiry(
        _favoriteAdsCacheKey,
        cacheData,
        expiry: const Duration(days: 7),
      );
      dev.log('Favorite ads saved successfully');
    } catch (e) {
      dev.log('Error saving favorite ads: $e');
      throw const CacheException('Failed to save favorite ads');
    }
  }

  @override
  Future<List<AdModel>> getRecentlyViewedAds() async {
    try {
      final cacheData = StorageService.getCacheIfValid(_recentlyViewedCacheKey);
      if (cacheData != null) {
        final adsData = cacheData['ads'] as List;
        return adsData.map((adJson) => AdModel.fromJson(adJson)).toList();
      }
      return [];
    } catch (e) {
      dev.log('Error getting recently viewed ads: $e');
      return [];
    }
  }

  @override
  Future<void> addToRecentlyViewed(AdModel ad) async {
    try {
      final currentAds = await getRecentlyViewedAds();
      currentAds.removeWhere((existingAd) => existingAd.id == ad.id);
      currentAds.insert(0, ad);
      if (currentAds.length > _maxRecentlyViewed) {
        currentAds.removeRange(_maxRecentlyViewed, currentAds.length);
      }
      final cacheData = {
        'ads': currentAds.map((ad) => ad.toJson()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      };
      await StorageService.setCacheWithExpiry(
        _recentlyViewedCacheKey,
        cacheData,
        expiry: const Duration(days: 30),
      );
      dev.log('Ad added to recently viewed: ${ad.id}');
    } catch (e) {
      dev.log('Error adding to recently viewed: $e');
      throw const CacheException('Failed to add to recently viewed');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_favoriteAdsCacheKey);
      await StorageService.remove(_recentlyViewedCacheKey);

      dev.log('Ads cache cleared successfully');
    } catch (e) {
      dev.log('Error clearing ads cache: $e');
      throw const CacheException('Failed to clear ads cache');
    }
  }
}
