import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/home_job_model.dart';
import '../models/post_model.dart';

abstract class VJobHomeRemoteDataSource {
  Future<JobsResponseModel> getJobs({int page = 1, int limit = 10});
  Future<bool> saveJob(String jobId);
  Future<bool> applyJob(String jobId);
  Future<PostsResponseModel> getPosts({int page = 1, int limit = 10});
  Future<PostsResponseModel> getMyPosts();
  Future<bool> likePost(String postId);
  Future<bool> deletePost(String postId);
}

class VJobHomeRemoteDataSourceImpl implements VJobHomeRemoteDataSource {
  final ApiClient apiClient;

  VJobHomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<JobsResponseModel> getJobs({int page = 1, int limit = 10}) async {
    try {
      final response = await apiClient.get(
        'user/get-job',
        queryParameters: {'page': page.toString(), 'limit': limit.toString()},
      );

      final data = json.decode(response.body);
      return JobsResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> saveJob(String jobId) async {
    try {
      final response = await apiClient.post(
        'api/jobs/save',
        body: {'id': jobId},
      );

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> applyJob(String jobId) async {
    try {
      final response = await apiClient.post(
        'api/jobs/apply',
        body: {'id': jobId},
      );

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostsResponseModel> getPosts({int page = 1, int limit = 10}) async {
    try {
      final response = await apiClient.get('user/get-job-post');
      final data = json.decode(response.body);
      return PostsResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PostsResponseModel> getMyPosts() async {
    try {
      final response = await apiClient.get('api/posts/myPosts');
      final data = json.decode(response.body);
      return PostsResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> likePost(String postId) async {
    try {
      final response = await apiClient.post(
        'api/posts/like',
        body: {'postId': postId},
      );

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> deletePost(String postId) async {
    try {
      final response = await apiClient.post(
        'api/posts/action',
        body: {'postId': postId, 'action': 'delete'},
      );

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
