import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/my_post_model.dart';

abstract class MyPostLocalDataSource {
  Future<List<MyPostModel>> getCachedMyPosts();
  Future<void> cacheMyPosts(List<MyPostModel> posts);
  Future<MyPostModel?> getCachedPostById(String postId);
  Future<void> cachePost(MyPostModel post);
  Future<PostStatsModel?> getCachedPostStats();
  Future<void> cachePostStats(PostStatsModel stats);
  Future<void> clearCache();
  Future<void> removePostFromCache(String postId);
  Future<void> updatePostInCache(MyPostModel post);
}

class MyPostLocalDataSourceImpl implements MyPostLocalDataSource {
  static const String _myPostsKey = 'my_posts_cache';
  static const String _postStatsKey = 'post_stats_cache';
  static const String _postPrefix = 'post_';

  @override
  Future<List<MyPostModel>> getCachedMyPosts() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_myPostsKey);
      if (cachedData != null) {
        final List<dynamic> postsList = cachedData['posts'] ?? [];
        return postsList.map((post) => MyPostModel.fromJson(post)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get cached posts: $e');
    }
  }

  @override
  Future<void> cacheMyPosts(List<MyPostModel> posts) async {
    try {
      final postsJson = posts.map((post) => post.toJson()).toList();
      await StorageService.setCacheWithExpiry(_myPostsKey, {
        'posts': postsJson,
      }, expiry: const Duration(minutes: 15));
    } catch (e) {
      throw CacheException('Failed to cache posts: $e');
    }
  }

  @override
  Future<MyPostModel?> getCachedPostById(String postId) async {
    try {
      final cachedData = StorageService.getCacheIfValid('$_postPrefix$postId');
      if (cachedData != null) {
        return MyPostModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached post: $e');
    }
  }

  @override
  Future<void> cachePost(MyPostModel post) async {
    try {
      await StorageService.setCacheWithExpiry(
        '$_postPrefix${post.id}',
        post.toJson(),
        expiry: const Duration(minutes: 30),
      );
    } catch (e) {
      throw CacheException('Failed to cache post: $e');
    }
  }

  @override
  Future<PostStatsModel?> getCachedPostStats() async {
    try {
      final cachedData = StorageService.getCacheIfValid(_postStatsKey);
      if (cachedData != null) {
        return PostStatsModel.fromJson(cachedData);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached post stats: $e');
    }
  }

  @override
  Future<void> cachePostStats(PostStatsModel stats) async {
    try {
      await StorageService.setCacheWithExpiry(
        _postStatsKey,
        stats.toJson(),
        expiry: const Duration(minutes: 10),
      );
    } catch (e) {
      throw CacheException('Failed to cache post stats: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_myPostsKey);
      await StorageService.remove(_postStatsKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> removePostFromCache(String postId) async {
    try {
      await StorageService.remove('$_postPrefix$postId');

      // Also remove from the posts list cache
      final cachedPosts = await getCachedMyPosts();
      final updatedPosts = cachedPosts
          .where((post) => post.id != postId)
          .toList();
      await cacheMyPosts(updatedPosts);
    } catch (e) {
      throw CacheException('Failed to remove post from cache: $e');
    }
  }

  @override
  Future<void> updatePostInCache(MyPostModel post) async {
    try {
      await cachePost(post);

      // Update in the posts list cache
      final cachedPosts = await getCachedMyPosts();
      final updatedPosts = cachedPosts.map((cachedPost) {
        return cachedPost.id == post.id ? post : cachedPost;
      }).toList();
      await cacheMyPosts(updatedPosts);
    } catch (e) {
      throw CacheException('Failed to update post in cache: $e');
    }
  }
}
