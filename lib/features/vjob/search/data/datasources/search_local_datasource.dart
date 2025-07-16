import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/recent_search_model.dart';
import '../models/search_jobs_model.dart';

abstract class SearchLocalDataSource {
  Future<RecentSearchesResponseModel?> getCachedRecentSearches();
  Future<void> cacheRecentSearches(RecentSearchesResponseModel searches);
  Future<SearchJobsResponseModel?> getCachedSearchResults(String query);
  Future<void> cacheSearchResults(
    String query,
    SearchJobsResponseModel results,
  );
  Future<void> clearCache();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const String _recentSearchesCacheKey = 'cached_recent_searches';
  static const String _searchResultsCachePrefix = 'cached_search_results_';

  @override
  Future<RecentSearchesResponseModel?> getCachedRecentSearches() async {
    try {
      final cachedData = StorageService.getCacheIfValid(
        _recentSearchesCacheKey,
      );
      if (cachedData != null) {
        return RecentSearchesResponseModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached recent searches: $e');
    }
  }

  @override
  Future<void> cacheRecentSearches(RecentSearchesResponseModel searches) async {
    try {
      await StorageService.setCacheWithExpiry(
        _recentSearchesCacheKey,
        searches.toJson(),
        expiry: const Duration(hours: 1),
      );
    } catch (e) {
      throw CacheException('Failed to cache recent searches: $e');
    }
  }

  @override
  Future<SearchJobsResponseModel?> getCachedSearchResults(String query) async {
    try {
      final cacheKey = '$_searchResultsCachePrefix${query.toLowerCase()}';
      final cachedData = StorageService.getCacheIfValid(cacheKey);
      if (cachedData != null) {
        return SearchJobsResponseModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached search results: $e');
    }
  }

  @override
  Future<void> cacheSearchResults(
    String query,
    SearchJobsResponseModel results,
  ) async {
    try {
      final cacheKey = '$_searchResultsCachePrefix${query.toLowerCase()}';
      await StorageService.setCacheWithExpiry(
        cacheKey,
        results.toJson(),
        expiry: const Duration(minutes: 30),
      );
    } catch (e) {
      throw CacheException('Failed to cache search results: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_recentSearchesCacheKey);
      // Clear all search results cache keys would require a different approach
      // This is a simplified implementation
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
