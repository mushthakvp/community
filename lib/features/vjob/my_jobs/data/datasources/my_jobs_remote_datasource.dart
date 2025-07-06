import 'dart:convert';

import 'package:livera/core/constants/api_constants.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/my_job_model.dart';

/// Abstract remote data source for My Jobs
abstract class MyJobsRemoteDataSource {
  /// Fetch user's jobs by status with pagination
  Future<MyJobsResponseModel> getMyJobs({
    required String status,
    int page = 1,
    int limit = 10,
  });

  /// Update job status (save/unsave)
  Future<bool> updateJobStatus({required String jobId, required String action});

  /// Remove job from user's list
  Future<bool> removeJob(String jobId);
}

/// Implementation of MyJobsRemoteDataSource
class MyJobsRemoteDataSourceImpl implements MyJobsRemoteDataSource {
  final ApiClient? apiClient;

  MyJobsRemoteDataSourceImpl({this.apiClient});

  @override
  Future<MyJobsResponseModel> getMyJobs({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url =
          'user/get-saved-applied-jobs?status=$status&page=$page&limit=$limit';
      final response = await _makeRequest(url);
      if (response.first >= 200 && response.first < 300) {
        final responseData = response.last is String
            ? json.decode(response.last)
            : response.last;
        return MyJobsResponseModel.fromJson(responseData);
      } else {
        throw ServerException(
          response.last?.toString() ?? 'Unknown server error',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> updateJobStatus({
    required String jobId,
    required String action,
  }) async {
    try {
      final data = {"id": jobId};
      final response = await _makePostRequest(
        ApiConstants.saveJobCandidate,
        data,
      );
      if (response.first >= 200 && response.first < 300) {
        return true;
      } else {
        throw ServerException(
          response.last?.toString() ?? 'Failed to update job status',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> removeJob(String jobId) async {
    try {
      return await updateJobStatus(jobId: jobId, action: 'remove');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  Future<List<dynamic>> _makeRequest(String url) async {
    try {
      if (apiClient != null) {
        final response = await apiClient!.get(url);
        final data = json.decode(response.body);
        return [response.statusCode, data];
      } else {
        throw UnimplementedError(
          'ApiClient not provided. Please inject ApiClient or implement ServerClientServices fallback.',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> _makePostRequest(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      if (apiClient != null) {
        final response = await apiClient!.post(endpoint, body: data);
        final responseData = json.decode(response.body);
        return [response.statusCode, responseData];
      } else {
        throw UnimplementedError(
          'ApiClient not provided. Please inject ApiClient or implement ServerClientServices fallback.',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
