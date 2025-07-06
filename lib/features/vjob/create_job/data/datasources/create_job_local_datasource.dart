import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/job_title_model.dart';

abstract class CreateJobLocalDataSource {
  Future<List<JobTitleModel>> getCachedJobTitles();
  Future<void> cacheJobTitles(List<JobTitleModel> titles);
  Future<void> clearCache();
}

class CreateJobLocalDataSourceImpl implements CreateJobLocalDataSource {
  static const String _jobTitlesCacheKey = 'cached_job_titles';

  @override
  Future<List<JobTitleModel>> getCachedJobTitles() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_jobTitlesCacheKey);
      if (cachedData != null) {
        final List<dynamic> titlesList = cachedData['titles'] ?? [];
        return titlesList
            .map((title) => JobTitleModel.fromJson(title))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached job titles: $e');
    }
  }

  @override
  Future<void> cacheJobTitles(List<JobTitleModel> titles) async {
    try {
      final titlesJson = titles.map((title) => title.toJson()).toList();
      await StorageService.setCacheWithExpiry(_jobTitlesCacheKey, {
        'titles': titlesJson,
      }, expiry: const Duration(hours: 24));
    } catch (e) {
      throw CacheException('Failed to cache job titles: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_jobTitlesCacheKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
