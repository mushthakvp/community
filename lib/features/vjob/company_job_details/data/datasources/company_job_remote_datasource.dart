import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/company_job_response_model.dart';

abstract class CompanyJobRemoteDataSource {
  Future<JobDetailsResponseModel> getJobDetails(String jobId);
  Future<JobCandidatesResponseModel> getJobCandidates({
    required String jobId,
    int page = 1,
    int limit = 10,
  });
  Future<bool> markJobAsClosed(String jobId);
  Future<bool> reapplyJob(String jobId);
  Future<String> downloadCandidateCV(String candidateId);
}

class CompanyJobRemoteDataSourceImpl implements CompanyJobRemoteDataSource {
  final ApiClient apiClient;

  CompanyJobRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<JobDetailsResponseModel> getJobDetails(String jobId) async {
    try {
      final response = await apiClient.get(
        'user/get-job-detail',
        queryParameters: {'id': jobId},
      );

      final data = json.decode(response.body);
      return JobDetailsResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<JobCandidatesResponseModel> getJobCandidates({
    required String jobId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        'user/get-applied-candidates',
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
          'jobId': jobId,
        },
      );

      final data = json.decode(response.body);
      return JobCandidatesResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> markJobAsClosed(String jobId) async {
    try {
      final response = await apiClient.post(
        'user/mark-as-closed',
        body: {'jobId': jobId},
      );

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> reapplyJob(String jobId) async {
    try {
      final response = await apiClient.post(
        'user/re-apply-jobPost',
        body: {'jobId': jobId},
      );

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> downloadCandidateCV(String candidateId) async {
    try {
      final response = await apiClient.get('user/download-cv/$candidateId');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerException('Failed to download CV');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
