import 'dart:convert';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/create_job_model.dart';
import '../models/job_title_model.dart';

abstract class CreateJobRemoteDataSource {
  Future<JobTitlesResponseModel> getJobTitles();
  Future<bool> createJobTitle(String title);
  Future<bool> createJob(CreateJobModel job);
  Future<bool> updateJob(CreateJobModel job);
}

class CreateJobRemoteDataSourceImpl implements CreateJobRemoteDataSource {
  final ApiClient apiClient;

  CreateJobRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<JobTitlesResponseModel> getJobTitles() async {
    try {
      final response = await apiClient.get(ApiConstants.getTitles);
      final data = json.decode(response.body);
      return JobTitlesResponseModel.fromJson(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> createJobTitle(String title) async {
    try {
      final response = await apiClient.post(
        ApiConstants.createJobTitle,
        body: {'title': title},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final data = json.decode(response.body);
        throw ServerException(data['message'] ?? 'Failed to create job title');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> createJob(CreateJobModel job) async {
    try {
      final response = await apiClient.post(
        ApiConstants.createJob,
        body: job.toJson(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final data = json.decode(response.body);
        throw ServerException(data['message'] ?? 'Failed to create job');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> updateJob(CreateJobModel job) async {
    try {
      final response = await apiClient.post(
        ApiConstants.createJob,
        body: job.toJson(isUpdate: true),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final data = json.decode(response.body);
        throw ServerException(data['message'] ?? 'Failed to update job');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
