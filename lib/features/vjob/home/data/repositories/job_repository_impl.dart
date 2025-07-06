import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/api_client.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/job_repository.dart';
import '../models/job_model.dart';
import '../models/jobs_response_model.dart';

class JobRepositoryImpl implements JobRepository {
  final ApiClient _apiClient;

  JobRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<JobEntity>>> getJobs({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.get(
        '/user/get-job',
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jobsResponse = JobsResponseModel.fromJson(responseData);
        if (jobsResponse.success) {
          return Right(jobsResponse.jobs);
        } else {
          return Left(ServerFailure(message: jobsResponse.message));
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load jobs',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getJobs: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getJobs: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log('Unexpected error in getJobs', error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, JobEntity>> getJobDetails(String jobId) async {
    try {
      if (jobId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid job ID'));
      }

      final response = await _apiClient.get('/user/get-job-detail?id=$jobId');
      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseData['success'] == true && responseData['job'] != null) {
          final job = JobModel.fromJson(responseData['job']);
          return Right(job);
        } else {
          return Left(
            ServerFailure(message: responseData['message'] ?? 'Job not found'),
          );
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to load job details',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getJobDetails: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getJobDetails: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getJobDetails',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveJob(String jobId) async {
    try {
      if (jobId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid job ID'));
      }

      final response = await _apiClient.post(
        '/user/save-job?id=$jobId',
        body: {'id': jobId},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(true);
      } else {
        final responseData = json.decode(response.body);
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to save job',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in saveJob: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in saveJob: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log('Unexpected error in saveJob', error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> applyJob({
    required String jobId,
    required String resume,
  }) async {
    try {
      if (jobId.isEmpty) {
        return const Left(ValidationFailure(message: 'Invalid job ID'));
      }
      if (resume.isEmpty) {
        return const Left(ValidationFailure(message: 'Resume is required'));
      }

      final response = await _apiClient.post(
        '/user/apply-job',
        body: {'id': jobId, 'resume': resume},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return const Right(true);
      } else {
        final responseData = json.decode(response.body);
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to apply for job',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in applyJob: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in applyJob: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log('Unexpected error in applyJob', error: e, stackTrace: stackTrace);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JobEntity>>> searchJobs({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (query.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Search query cannot be empty'),
        );
      }

      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        'search': query.trim(),
      };

      final response = await _apiClient.get(
        '/user/get-job',
        queryParameters: queryParams,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jobsResponse = JobsResponseModel.fromJson(responseData);
        if (jobsResponse.success) {
          return Right(jobsResponse.jobs);
        } else {
          return Left(ServerFailure(message: jobsResponse.message));
        }
      } else {
        return Left(
          ServerFailure(
            message: responseData['message'] ?? 'Failed to search jobs',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in searchJobs: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in searchJobs: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in searchJobs',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
