import 'dart:convert';

import '../../../../../core/services/storage_service.dart';
import '../../domain/entities/search_result.dart';
import '../models/search_result_model.dart';

abstract class SearchLocalDataSource {
  Future<SearchResult?> getCachedSearchResult(String query);
  Future<void> cacheSearchResult(SearchResult result);
  Future<void> saveRecentSearch(String query);
  Future<List<String>> getRecentSearches();
  Future<void> clearRecentSearches();
  Future<void> clearSearchCache();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const String _recentSearchesKey = 'cook_recent_searches';
  static const String _searchCachePrefix = 'cook_search_cache_';
  static const int _maxRecentSearches = 10;

  @override
  Future<SearchResult?> getCachedSearchResult(String query) async {
    try {
      final key = '$_searchCachePrefix${query.toLowerCase()}';
      final jsonString = StorageService.getString(key);
      if (jsonString != null) {
        final json = jsonDecode(jsonString);
        return SearchResultModel.fromJson(json, query);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheSearchResult(SearchResult result) async {
    try {
      final key = '$_searchCachePrefix${result.query.toLowerCase()}';
      final model = SearchResultModel(
        challenges: result.challenges,
        query: result.query,
        totalResults: result.totalResults,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
      );
      final jsonString = jsonEncode(model.toJson());
      await StorageService.setString(key, jsonString);
    } catch (e) {
      // Ignore cache errors
    }
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    try {
      if (query.trim().isEmpty) return;
      final recentSearches = await getRecentSearches();
      recentSearches.remove(query);
      recentSearches.insert(0, query);
      if (recentSearches.length > _maxRecentSearches) {
        recentSearches.removeRange(_maxRecentSearches, recentSearches.length);
      }
      final jsonString = jsonEncode(recentSearches);
      await StorageService.setString(_recentSearchesKey, jsonString);
    } catch (e) {
      // Ignore errors
    }
  }

  @override
  Future<List<String>> getRecentSearches() async {
    try {
      final jsonString = StorageService.getString(_recentSearchesKey);
      if (jsonString != null) {
        final List<dynamic> json = jsonDecode(jsonString);
        return json.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await StorageService.remove(_recentSearchesKey);
    } catch (e) {
      // Ignore errors
    }
  }

  @override
  Future<void> clearSearchCache() async {
    try {
      await clearRecentSearches();
    } catch (e) {
      // Ignore errors
    }
  }
}
