import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../core/constants/vcart_constants.dart';
import '../models/category_model.dart';
import '../models/section_model.dart';

abstract class CategoriesLocalDataSource {
  Future<List<SectionModel>?> getCachedSections();
  Future<void> cacheSections(List<SectionModel> sections);
  Future<List<CategoryItemModel>?> getCachedCategories(String sectionId);
  Future<void> cacheCategories(
    String sectionId,
    List<CategoryItemModel> categories,
  );
  Future<void> clearCache();
}

class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  static const String _sectionsKey = '${VCartConstants.cacheKeyPrefix}sections';
  static const String _categoriesPrefix =
      '${VCartConstants.cacheKeyPrefix}categories_';
  static const String _timestampKey =
      '${VCartConstants.cacheKeyPrefix}categories_timestamp';

  @override
  Future<List<SectionModel>?> getCachedSections() async {
    try {
      final timestampString = StorageService.getString(_timestampKey);
      if (timestampString == null) return null;

      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();

      if (now.difference(timestamp) > VCartConstants.cacheValidDuration) {
        await clearCache();
        return null;
      }

      final cachedData = StorageService.getString(_sectionsKey);
      if (cachedData == null) return null;

      final jsonList = json.decode(cachedData) as List;
      return jsonList
          .map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached sections: $e');
    }
  }

  @override
  Future<void> cacheSections(List<SectionModel> sections) async {
    try {
      final jsonString = json.encode(sections.map((e) => e.toJson()).toList());
      await StorageService.setString(_sectionsKey, jsonString);
      await StorageService.setString(
        _timestampKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw CacheException('Failed to cache sections: $e');
    }
  }

  @override
  Future<List<CategoryItemModel>?> getCachedCategories(String sectionId) async {
    try {
      final key = '$_categoriesPrefix$sectionId';
      final cachedData = StorageService.getString(key);
      if (cachedData == null) return null;

      final jsonList = json.decode(cachedData) as List;
      return jsonList
          .map((e) => CategoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get cached categories: $e');
    }
  }

  @override
  Future<void> cacheCategories(
    String sectionId,
    List<CategoryItemModel> categories,
  ) async {
    try {
      final key = '$_categoriesPrefix$sectionId';
      final jsonString = json.encode(
        categories.map((e) => e.toJson()).toList(),
      );
      await StorageService.setString(key, jsonString);
    } catch (e) {
      throw CacheException('Failed to cache categories: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_sectionsKey);
      await StorageService.remove(_timestampKey);
      // Note: We might want to clear all category caches too
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
