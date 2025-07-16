import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/home_job_model.dart';
import '../models/post_model.dart';

abstract class VJobHomeLocalDataSource {
  Future<List<HomeJobModel>> getCachedJobs();
  Future<void> cacheJobs(List<HomeJobModel> jobs);
  Future<List<PostModel>> getCachedPosts();
  Future<void> cachePosts(List<PostModel> posts);
  Future<void> clearCache();
}

class VJobHomeLocalDataSourceImpl implements VJobHomeLocalDataSource {
  static const String _jobsCacheKey = 'cached_jobs';
  static const String _postsCacheKey = 'cached_posts';

  @override
  Future<List<HomeJobModel>> getCachedJobs() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_jobsCacheKey);
      if (cachedData != null) {
        final List<dynamic> jobsList = cachedData['jobs'] ?? [];
        return jobsList.map((job) => HomeJobModel.fromJson(job)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached jobs: $e');
    }
  }

  @override
  Future<void> cacheJobs(List<HomeJobModel> jobs) async {
    try {
      final jobsJson = jobs.map((job) => job.toJson()).toList();
      await StorageService.setCacheWithExpiry(_jobsCacheKey, {
        'jobs': jobsJson,
      }, expiry: const Duration(minutes: 30));
    } catch (e) {
      throw CacheException('Failed to cache jobs: $e');
    }
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_postsCacheKey);
      if (cachedData != null) {
        final List<dynamic> postsList = cachedData['posts'] ?? [];
        return postsList.map((post) => PostModel.fromJson(post)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached posts: $e');
    }
  }

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    try {
      final postsJson = posts.map((post) => post.toJson()).toList();
      await StorageService.setCacheWithExpiry(_postsCacheKey, {
        'posts': postsJson,
      }, expiry: const Duration(minutes: 15));
    } catch (e) {
      throw CacheException('Failed to cache posts: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_jobsCacheKey);
      await StorageService.remove(_postsCacheKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }
}
