import 'dart:convert';
import 'dart:io';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/my_post_model.dart';

abstract class MyPostRemoteDataSource {
  Future<List<MyPostModel>> getMyPosts({int page = 1, int limit = 10});
  Future<MyPostModel> getPostById(String postId);
  Future<bool> likePost(String postId);
  Future<bool> deletePost(String postId);
  Future<PostStatsModel> getPostStats();
  Future<List<MyPostModel>> searchMyPosts(
    String query, {
    int page = 1,
    int limit = 10,
  });
}

class MyPostRemoteDataSourceImpl implements MyPostRemoteDataSource {
  final ApiClient apiClient;

  MyPostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MyPostModel>> getMyPosts({int page = 1, int limit = 10}) async {
    try {
      final response = await apiClient.get(
        'user/get-job-post?type=myPosts',
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseModel = MyPostsResponseModel.fromJson(data);
        if (responseModel.success) {
          return responseModel.posts;
        } else {
          throw ServerException(responseModel.message);
        }
      } else {
        throw ServerException(data['message'] ?? 'Failed to get posts');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to get posts: $e');
    }
  }

  @override
  Future<MyPostModel> getPostById(String postId) async {
    try {
      final response = await apiClient.get('/api/posts/$postId');
      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseModel = PostActionResponseModel.fromJson(data);
        if (responseModel.success && responseModel.post != null) {
          return responseModel.post!;
        } else {
          throw ServerException(responseModel.message);
        }
      } else {
        throw ServerException(data['message'] ?? 'Failed to get post');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to get post: $e');
    }
  }

  @override
  Future<bool> likePost(String postId) async {
    try {
      final response = await apiClient.post(
        '/api/posts/like',
        body: {'postId': postId},
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data['success'] ?? false;
      } else {
        throw ServerException(data['message'] ?? 'Failed to like post');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to like post: $e');
    }
  }

  @override
  Future<bool> deletePost(String postId) async {
    try {
      final response = await apiClient.post(
        'user/job-post-action',
        body: {'postId': postId, 'action': 'delete'},
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data['success'] ?? false;
      } else {
        throw ServerException(data['message'] ?? 'Failed to delete post');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to delete post: $e');
    }
  }

  @override
  Future<PostStatsModel> getPostStats() async {
    try {
      final response = await apiClient.get('/api/posts/stats');
      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseModel = PostStatsResponseModel.fromJson(data);
        if (responseModel.success) {
          return responseModel.stats;
        } else {
          throw ServerException(responseModel.message);
        }
      } else {
        throw ServerException(data['message'] ?? 'Failed to get post stats');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to get post stats: $e');
    }
  }

  @override
  Future<List<MyPostModel>> searchMyPosts(
    String query, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        '/api/posts/search/myPosts',
        queryParameters: {
          'query': query,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseModel = MyPostsResponseModel.fromJson(data);
        if (responseModel.success) {
          return responseModel.posts;
        } else {
          throw ServerException(responseModel.message);
        }
      } else {
        throw ServerException(data['message'] ?? 'Failed to search posts');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to search posts: $e');
    }
  }
}
