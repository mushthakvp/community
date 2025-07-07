import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/company_model.dart';
import '../models/created_job_model.dart';
import '../models/job_candidate_model.dart';

abstract class MyCompanyRemoteDataSource {
  Future<CompanyResponseModel> getMyCompany();
  Future<CreatedJobsResponseModel> getCreatedJobs({
    required String companyId,
    required String status,
    required int page,
    required int limit,
  });
  Future<JobCandidatesResponseModel> getJobCandidates({
    required String jobId,
    required int page,
    required int limit,
  });
  Future<bool> reapplyJob(String jobId);
  Future<bool> markJobAsClosed(String jobId);
}

class MyCompanyRemoteDataSourceImpl implements MyCompanyRemoteDataSource {
  final ApiClient apiClient;

  MyCompanyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CompanyResponseModel> getMyCompany() async {
    try {
      final response = await apiClient.get(
        '/user/get-my-companies?limit=10&page=1',
      );
      final data = json.decode(response.body);
      return CompanyResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CreatedJobsResponseModel> getCreatedJobs({
    required String companyId,
    required String status,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiClient.get(
        '/user/get-posted-companyJobs?company=$companyId&status=$status&limit=$limit&page=$page',
      );
      final data = json.decode(response.body);
      return CreatedJobsResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<JobCandidatesResponseModel> getJobCandidates({
    required String jobId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await apiClient.get(
        '/user/get-applied-candidates?jobId=$jobId&page=$page&limit=$limit',
      );
      final data = json.decode(response.body);
      return JobCandidatesResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> reapplyJob(String jobId) async {
    try {
      final response = await apiClient.post(
        '/user/re-apply-jobPost',
        body: {'id': jobId},
      );
      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> markJobAsClosed(String jobId) async {
    try {
      final response = await apiClient.post(
        '/user/mark-as-closed',
        body: {'jobId': jobId},
      );
      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
