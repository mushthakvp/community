import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/api_client.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/posts_response_model.dart';

class PostRepositoryImpl implements PostRepository {
  final ApiClient _apiClient;

  PostRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    int page = 1,
    int limit = 10,
    String type = 'all',
  }) async {
    try {
      final response = await _apiClient.get('/user/get-job-post?type=$type');
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final postsResponse = PostsResponseModel.fromJson(responseData);
        if (postsResponse.success) {
          return Right(postsResponse.posts);
        } else {
          return Left(ServerFailure(message: postsResponse.message));
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load posts',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getPosts: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getPosts: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log('Unexpected error in getPosts', error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> likePost(String postId) async {
    try {
      if (postId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid post ID'));
      }

      final response = await _apiClient.post(
        '/user/like-job-post',
        body: {'postId': postId},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(true);
      } else {
        final responseData = json.decode(response.body);
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to like post',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in likePost: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in likePost: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log('Unexpected error in likePost', error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getMyPosts() async {
    try {
      final response = await _apiClient.get('/user/get-job-post?type=myPosts');
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final postsResponse = PostsResponseModel.fromJson(responseData);
        if (postsResponse.success) {
          return Right(postsResponse.posts);
        } else {
          return Left(ServerFailure(message: postsResponse.message));
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load my posts',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getMyPosts: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getMyPosts: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getMyPosts',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
