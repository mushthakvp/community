import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/my_job_model.dart';

/// Abstract local data source for My Jobs caching
abstract class MyJobsLocalDataSource {
  /// Get cached jobs by status
  Future<List<MyJobModel>> getCachedJobs(String status);

  /// Cache jobs by status
  Future<void> cacheJobs(String status, List<MyJobModel> jobs);

  /// Get cached job by ID
  Future<MyJobModel?> getCachedJob(String jobId);

  /// Update cached job
  Future<void> updateCachedJob(MyJobModel job);

  /// Remove job from cache
  Future<void> removeCachedJob(String jobId, String status);

  /// Clear all cache
  Future<void> clearCache();

  /// Clear cache by status
  Future<void> clearCacheByStatus(String status);
}

/// Implementation of MyJobsLocalDataSource
class MyJobsLocalDataSourceImpl implements MyJobsLocalDataSource {
  static const String _appliedJobsCacheKey = 'cached_applied_jobs';
  static const String _savedJobsCacheKey = 'cached_saved_jobs';
  static const Duration _cacheExpiry = Duration(minutes: 30);

  @override
  Future<List<MyJobModel>> getCachedJobs(String status) async {
    try {
      final cacheKey = _getCacheKey(status);
      final cachedData = StorageService.getCacheIfValid(cacheKey);

      if (cachedData != null) {
        final List<dynamic> jobsList = cachedData['jobs'] ?? [];
        final jobs = jobsList.map((job) => MyJobModel.fromJson(job)).toList();
        return jobs;
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached jobs: $e');
    }
  }

  @override
  Future<void> cacheJobs(String status, List<MyJobModel> jobs) async {
    try {
      final cacheKey = _getCacheKey(status);
      final jobsJson = jobs.map((job) => job.toJson()).toList();

      await StorageService.setCacheWithExpiry(cacheKey, {
        'jobs': jobsJson,
        'status': status,
        'timestamp': DateTime.now().toIso8601String(),
      }, expiry: _cacheExpiry);
    } catch (e) {
      throw CacheException('Failed to cache jobs: $e');
    }
  }

  @override
  Future<MyJobModel?> getCachedJob(String jobId) async {
    try {
      for (final status in ['Applied', 'Saved']) {
        final jobs = await getCachedJobs(status);
        final job = jobs.where((job) => job.id == jobId).firstOrNull;
        if (job != null) {
          return job;
        }
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached job: $e');
    }
  }

  @override
  Future<void> updateCachedJob(MyJobModel job) async {
    try {
      for (final status in ['Applied', 'Saved']) {
        final jobs = await getCachedJobs(status);
        final index = jobs.indexWhere((cachedJob) => cachedJob.id == job.id);

        if (index != -1) {
          jobs[index] = job;
          await cacheJobs(status, jobs);
        }
      }
    } catch (e) {
      throw CacheException('Failed to update cached job: $e');
    }
  }

  @override
  Future<void> removeCachedJob(String jobId, String status) async {
    try {
      final jobs = await getCachedJobs(status);
      final updatedJobs = jobs.where((job) => job.id != jobId).toList();
      await cacheJobs(status, updatedJobs);
    } catch (e) {
      throw CacheException('Failed to remove cached job: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_appliedJobsCacheKey);
      await StorageService.remove(_savedJobsCacheKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> clearCacheByStatus(String status) async {
    try {
      final cacheKey = _getCacheKey(status);
      await StorageService.remove(cacheKey);
    } catch (e) {
      throw CacheException('Failed to clear cache by status: $e');
    }
  }

  String _getCacheKey(String status) {
    switch (status.toLowerCase()) {
      case 'applied':
        return _appliedJobsCacheKey;
      case 'saved':
        return _savedJobsCacheKey;
      default:
        return '${status.toLowerCase()}_jobs_cache';
    }
  }
}

extension _IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}
