import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/job_details_model.dart';

abstract class JobDetailsLocalDataSource {
  Future<JobDetailsModel?> getCachedJobDetails(String jobId);
  Future<void> cacheJobDetails(String jobId, JobDetailsModel jobDetails);
  Future<void> clearCache();
}

class JobDetailsLocalDataSourceImpl implements JobDetailsLocalDataSource {
  static const String _cacheKeyPrefix = 'job_details_';

  @override
  Future<JobDetailsModel?> getCachedJobDetails(String jobId) async {
    try {
      final cacheKey = '$_cacheKeyPrefix$jobId';
      final cachedData = StorageService.getCacheIfValid(cacheKey);

      if (cachedData != null) {
        return JobDetailsModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached job details: $e');
    }
  }

  @override
  Future<void> cacheJobDetails(String jobId, JobDetailsModel jobDetails) async {
    try {
      final cacheKey = '$_cacheKeyPrefix$jobId';
      await StorageService.setCacheWithExpiry(
        cacheKey,
        jobDetails.toJson(),
        expiry: const Duration(hours: 1),
      );
    } catch (e) {
      throw CacheException('Failed to cache job details: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      // Implementation to clear all job details cache
      // This would depend on your storage service implementation
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
