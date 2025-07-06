import 'dart:convert';
import 'dart:developer' as dev;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/company_selection_model.dart';
import '../models/create_job_request_model.dart';
import '../models/create_job_response_model.dart';
import '../models/job_titles_response_model.dart';

abstract class CreateJobRemoteDataSource {
  Future<CreateJobResponseModel> createJob(CreateJobRequestModel request);
  Future<CreateJobResponseModel> updateJob({
    required String jobId,
    required CreateJobRequestModel request,
  });
  Future<JobTitlesResponseModel> getJobTitles();
  Future<CreateJobResponseModel> createJobTitle(String title);
  Future<List<CompanySelectionModel>> getUserCompanies();
}

class CreateJobRemoteDataSourceImpl implements CreateJobRemoteDataSource {
  final ApiClient _apiClient;

  CreateJobRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<CreateJobResponseModel> createJob(
    CreateJobRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.createJob,
        body: request.toJson(),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return CreateJobResponseModel.fromJson(responseData);
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to create job',
        );
      }
    } catch (e) {
      dev.log('Error creating job: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create job');
    }
  }

  @override
  Future<CreateJobResponseModel> updateJob({
    required String jobId,
    required CreateJobRequestModel request,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.createJob,
        body: request.toUpdateJson(jobId),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return CreateJobResponseModel.fromJson(responseData);
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to update job',
        );
      }
    } catch (e) {
      dev.log('Error updating job: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update job');
    }
  }

  @override
  Future<JobTitlesResponseModel> getJobTitles() async {
    try {
      final response = await _apiClient.get(ApiConstants.getTitles);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return JobTitlesResponseModel.fromJson(responseData);
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to get job titles',
        );
      }
    } catch (e) {
      dev.log('Error getting job titles: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get job titles');
    }
  }

  @override
  Future<CreateJobResponseModel> createJobTitle(String title) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.createJobTitle,
        body: {'title': title},
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return CreateJobResponseModel.fromJson(responseData);
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to create job title',
        );
      }
    } catch (e) {
      dev.log('Error creating job title: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create job title');
    }
  }

  @override
  Future<List<CompanySelectionModel>> getUserCompanies() async {
    try {
      final response = await _apiClient.get(ApiConstants.getMyCompanies);
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final companies =
            (responseData['companies'] as List<dynamic>?)
                ?.map((item) => CompanySelectionModel.fromJson(item))
                .toList() ??
            [];
        return companies;
      } else {
        throw ServerException(
          responseData['message'] ?? 'Failed to get companies',
        );
      }
    } catch (e) {
      dev.log('Error getting companies: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get companies');
    }
  }
}
