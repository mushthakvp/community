import 'dart:convert';
import 'dart:io';

import 'package:livera/core/services/cloudinary_service.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/create_post_model.dart';

abstract class CreatePostRemoteDataSource {
  Future<CreatePostModel> createPost(CreatePostRequestModel request);
  Future<CreatePostModel> updatePost(UpdatePostRequestModel request);
  Future<String> uploadImage(String imagePath);
  Future<bool> deletePost(String postId);
}

class CreatePostRemoteDataSourceImpl implements CreatePostRemoteDataSource {
  final ApiClient apiClient;

  CreatePostRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CreatePostModel> createPost(CreatePostRequestModel request) async {
    try {
      final response = await apiClient.post(
        'user/create-job-post',
        body: request.toJson(),
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseModel = CreatePostResponseModel.fromJson(data);
        if (responseModel.success && responseModel.post != null) {
          return responseModel.post!;
        } else {
          throw ServerException(responseModel.message);
        }
      } else {
        throw ServerException(data['message'] ?? 'Failed to create post');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to create post: $e');
    }
  }

  @override
  Future<CreatePostModel> updatePost(UpdatePostRequestModel request) async {
    try {
      final response = await apiClient.post(
        'user/job-post-action',
        body: request.toJson(),
      );

      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseModel = CreatePostResponseModel.fromJson(data);
        if (responseModel.success && responseModel.post != null) {
          return responseModel.post!;
        } else {
          throw ServerException(responseModel.message);
        }
      } else {
        throw ServerException(data['message'] ?? 'Failed to update post');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to update post: $e');
    }
  }

  @override
  Future<String> uploadImage(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      String? url = await CloudinaryService.uploadSingleImage(file: imageFile);
      return url ?? '';
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException('Failed to upload image: $e');
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
}
