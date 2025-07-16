import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/company_job_candidate_model.dart';
import '../models/company_job_response_model.dart';

abstract class CompanyJobLocalDataSource {
  Future<CompanyJobModel?> getCachedJobDetails(String jobId);
  Future<void> cacheJobDetails(CompanyJobModel job);
  Future<List<CandidateModel>> getCachedCandidates(String jobId);
  Future<void> cacheCandidates(String jobId, List<CandidateModel> candidates);
  Future<void> clearCache();
  Future<void> clearCacheForJob(String jobId);
}

class CompanyJobLocalDataSourceImpl implements CompanyJobLocalDataSource {
  static const String _jobDetailsCachePrefix = 'job_details_';
  static const String _candidatesCachePrefix = 'job_candidates_';

  @override
  Future<CompanyJobModel?> getCachedJobDetails(String jobId) async {
    try {
      final cacheKey = '$_jobDetailsCachePrefix$jobId';
      final cachedData = StorageService.getCacheIfValid(cacheKey);

      if (cachedData != null) {
        return CompanyJobModel.fromJson(cachedData['job']);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached job details: $e');
    }
  }

  @override
  Future<void> cacheJobDetails(CompanyJobModel job) async {
    try {
      final cacheKey = '$_jobDetailsCachePrefix${job.id}';
      await StorageService.setCacheWithExpiry(cacheKey, {
        'job': job.toJson(),
      }, expiry: const Duration(hours: 1));
    } catch (e) {
      throw CacheException('Failed to cache job details: $e');
    }
  }

  @override
  Future<List<CandidateModel>> getCachedCandidates(String jobId) async {
    try {
      final cacheKey = '$_candidatesCachePrefix$jobId';
      final cachedData = StorageService.getCacheIfValid(cacheKey);

      if (cachedData != null) {
        final List<dynamic> candidatesList = cachedData['candidates'] ?? [];
        return candidatesList
            .map((candidate) => CandidateModel.fromJson(candidate))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached candidates: $e');
    }
  }

  @override
  Future<void> cacheCandidates(
    String jobId,
    List<CandidateModel> candidates,
  ) async {
    try {
      final cacheKey = '$_candidatesCachePrefix$jobId';
      final candidatesJson = candidates
          .map((candidate) => candidate.toJson())
          .toList();

      await StorageService.setCacheWithExpiry(cacheKey, {
        'candidates': candidatesJson,
      }, expiry: const Duration(minutes: 30));
    } catch (e) {
      throw CacheException('Failed to cache candidates: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.clear();
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> clearCacheForJob(String jobId) async {
    try {
      await StorageService.remove('$_jobDetailsCachePrefix$jobId');
      await StorageService.remove('$_candidatesCachePrefix$jobId');
    } catch (e) {
      throw CacheException('Failed to clear cache for job: $e');
    }
  }
}
