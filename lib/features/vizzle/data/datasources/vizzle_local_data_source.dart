import 'dart:convert';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../models/vizzle_models.dart';

abstract class VizzleLocalDataSource {
  Future<VizzleHomeModel> getLastVizzleHome();
  Future<void> cacheVizzleHome(VizzleHomeModel vizzleHome);
  Future<List<CategoryModel>> getLastCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<List<AdModel>> getFavoriteAds();
  Future<void> addToFavorites(String adId);
  Future<void> removeFromFavorites(String adId);
  Future<List<AdModel>> getRecentlyViewedAds();
  Future<void> addToRecentlyViewed(String adId);
  Future<void> clearCache();
}

class VizzleLocalDataSourceImpl implements VizzleLocalDataSource {
  static const String _vizzleHomeCacheKey = 'vizzle_home_cache';
  static const String _categoriesCacheKey = 'vizzle_categories_cache';
  static const String _favoriteAdsCacheKey = 'vizzle_favorite_ads_cache';
  static const String _recentlyViewedCacheKey = 'vizzle_recently_viewed_cache';
  static const String _vizzleHomeCacheTimeKey = 'vizzle_home_cache_time';
  static const String _categoriesCacheTimeKey = 'vizzle_categories_cache_time';

  // Cache duration in hours
  static const int _cacheDurationHours = 24;

  @override
  Future<VizzleHomeModel> getLastVizzleHome() async {
    try {
      final cacheTime = StorageService.getString(_vizzleHomeCacheTimeKey);
      if (cacheTime != null) {
        final cacheDateTime = DateTime.parse(cacheTime);
        final now = DateTime.now();
        final difference = now.difference(cacheDateTime).inHours;

        if (difference > _cacheDurationHours) {
          throw const CacheException('Cache expired');
        }
      }

      final cachedData = StorageService.getString(_vizzleHomeCacheKey);
      if (cachedData != null) {
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        return VizzleHomeModel.fromJson(jsonData);
      } else {
        throw const CacheException('No cached vizzle home data');
      }
    } catch (e) {
      throw const CacheException('Failed to get cached vizzle home data');
    }
  }

  @override
  Future<void> cacheVizzleHome(VizzleHomeModel vizzleHome) async {
    try {
      final jsonData = json.encode(vizzleHome.toJson());
      await StorageService.setString(_vizzleHomeCacheKey, jsonData);
      await StorageService.setString(
        _vizzleHomeCacheTimeKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw const CacheException('Failed to cache vizzle home data');
    }
  }

  @override
  Future<List<CategoryModel>> getLastCategories() async {
    try {
      final cacheTime = StorageService.getString(_categoriesCacheTimeKey);
      if (cacheTime != null) {
        final cacheDateTime = DateTime.parse(cacheTime);
        final now = DateTime.now();
        final difference = now.difference(cacheDateTime).inHours;

        if (difference > _cacheDurationHours) {
          throw const CacheException('Cache expired');
        }
      }

      final cachedData = StorageService.getString(_categoriesCacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonData = json.decode(cachedData);
        return jsonData
            .map((category) => CategoryModel.fromJson(category))
            .toList();
      } else {
        throw const CacheException('No cached categories data');
      }
    } catch (e) {
      throw const CacheException('Failed to get cached categories data');
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final jsonData = json.encode(
        categories.map((cat) => cat.toJson()).toList(),
      );
      await StorageService.setString(_categoriesCacheKey, jsonData);
      await StorageService.setString(
        _categoriesCacheTimeKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw const CacheException('Failed to cache categories data');
    }
  }

  @override
  Future<List<AdModel>> getFavoriteAds() async {
    try {
      final cachedData = StorageService.getString(_favoriteAdsCacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonData = json.decode(cachedData);
        return jsonData.map((ad) => AdModel.fromJson(ad)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addToFavorites(String adId) async {
    try {
      final favoriteAds = await getFavoriteAds();
      final existingIndex = favoriteAds.indexWhere((ad) => ad.id == adId);
      if (existingIndex == -1) {
        final adModel = AdModel(id: adId, title: '', shareLink: '', images: []);
        favoriteAds.add(adModel);
        final jsonData = json.encode(
          favoriteAds.map((ad) => ad.toJson()).toList(),
        );
        await StorageService.setString(_favoriteAdsCacheKey, jsonData);
      }
    } catch (e) {
      throw const CacheException('Failed to add to favorites locally');
    }
  }

  @override
  Future<void> removeFromFavorites(String adId) async {
    try {
      final favoriteAds = await getFavoriteAds();
      favoriteAds.removeWhere((ad) => ad.id == adId);

      final jsonData = json.encode(
        favoriteAds.map((ad) => ad.toJson()).toList(),
      );
      await StorageService.setString(_favoriteAdsCacheKey, jsonData);
    } catch (e) {
      throw const CacheException('Failed to remove from favorites locally');
    }
  }

  @override
  Future<List<AdModel>> getRecentlyViewedAds() async {
    try {
      final cachedData = StorageService.getString(_recentlyViewedCacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonData = json.decode(cachedData);
        return jsonData.map((ad) => AdModel.fromJson(ad)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addToRecentlyViewed(String adId) async {
    try {
      const maxRecentlyViewed = 20;
      final recentlyViewed = await getRecentlyViewedAds();
      recentlyViewed.removeWhere((ad) => ad.id == adId);
      final adModel = AdModel(id: adId, title: '', shareLink: '', images: []);
      recentlyViewed.insert(0, adModel);
      if (recentlyViewed.length > maxRecentlyViewed) {
        recentlyViewed.removeRange(maxRecentlyViewed, recentlyViewed.length);
      }
      final jsonData = json.encode(
        recentlyViewed.map((ad) => ad.toJson()).toList(),
      );
      await StorageService.setString(_recentlyViewedCacheKey, jsonData);
    } catch (e) {
      throw const CacheException('Failed to add to recently viewed');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_vizzleHomeCacheKey);
      await StorageService.remove(_categoriesCacheKey);
      await StorageService.remove(_favoriteAdsCacheKey);
      await StorageService.remove(_recentlyViewedCacheKey);
      await StorageService.remove(_vizzleHomeCacheTimeKey);
      await StorageService.remove(_categoriesCacheTimeKey);
    } catch (e) {
      throw const CacheException('Failed to clear vizzle cache');
    }
  }
}
