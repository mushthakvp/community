import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/company_model.dart';
import '../models/created_job_model.dart';

abstract class MyCompanyLocalDataSource {
  Future<CompanyModel?> getCachedCompany();
  Future<void> cacheCompany(CompanyModel company);
  Future<List<CreatedJobModel>> getCachedJobs(String companyId);
  Future<void> cacheJobs(String companyId, List<CreatedJobModel> jobs);
  Future<void> clearCache();
}

class MyCompanyLocalDataSourceImpl implements MyCompanyLocalDataSource {
  static const String _companyCacheKey = 'cached_company';
  static const String _jobsCacheKeyPrefix = 'cached_jobs_';

  @override
  Future<CompanyModel?> getCachedCompany() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_companyCacheKey);
      if (cachedData != null) {
        return CompanyModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached company: $e');
    }
  }

  @override
  Future<void> cacheCompany(CompanyModel company) async {
    try {
      await StorageService.setCacheWithExpiry(
        _companyCacheKey,
        company.toJson(),
        expiry: const Duration(hours: 1),
      );
    } catch (e) {
      throw CacheException('Failed to cache company: $e');
    }
  }

  @override
  Future<List<CreatedJobModel>> getCachedJobs(String companyId) async {
    try {
      final cacheKey = '$_jobsCacheKeyPrefix$companyId';
      final cachedData = StorageService.getCacheIfValid(cacheKey);
      if (cachedData != null) {
        final List<dynamic> jobsList = cachedData['jobs'] ?? [];
        return jobsList.map((job) => CreatedJobModel.fromJson(job)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached jobs: $e');
    }
  }

  @override
  Future<void> cacheJobs(String companyId, List<CreatedJobModel> jobs) async {
    try {
      final cacheKey = '$_jobsCacheKeyPrefix$companyId';
      final jobsJson = jobs.map((job) => job.toJson()).toList();
      await StorageService.setCacheWithExpiry(cacheKey, {
        'jobs': jobsJson,
      }, expiry: const Duration(minutes: 30));
    } catch (e) {
      throw CacheException('Failed to cache jobs: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_companyCacheKey);
      // Note: You might want to implement a way to clear all job caches
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
