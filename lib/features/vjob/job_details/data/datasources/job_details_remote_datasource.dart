import 'dart:convert';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/apply_job_model.dart';
import '../models/job_details_model.dart';

abstract class JobDetailsRemoteDataSource {
  Future<JobDetailsModel> getJobDetails(String jobId);
  Future<ApplyJobModel> applyJob({
    required String jobId,
    required String resumeUrl,
  });
  Future<bool> saveJob(String jobId);
}

class JobDetailsRemoteDataSourceImpl implements JobDetailsRemoteDataSource {
  final ApiClient apiClient;

  JobDetailsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<JobDetailsModel> getJobDetails(String jobId) async {
    try {
      final response = await apiClient.get('user/get-job-detail?id=$jobId');
      final data = json.decode(response.body);
      return JobDetailsModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ApplyJobModel> applyJob({
    required String jobId,
    required String resumeUrl,
  }) async {
    try {
      final response = await apiClient.post(
        'user/apply-job',
        body: {'id': jobId, 'resume': resumeUrl},
      );

      final data = json.decode(response.body);
      return ApplyJobModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> saveJob(String jobId) async {
    try {
      final response = await apiClient.post(
        'user/save-job',
        body: {'id': jobId},
      );

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
