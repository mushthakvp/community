import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/company_selection_entity.dart';
import '../../domain/entities/create_job_entity.dart';
import '../../domain/entities/job_title_entity.dart';
import '../../domain/repositories/create_job_repository.dart';
import '../datasources/create_job_remote_datasource.dart';
import '../datasources/job_title_local_datasource.dart';
import '../models/create_job_request_model.dart';

class CreateJobRepositoryImpl implements CreateJobRepository {
  final CreateJobRemoteDataSource _remoteDataSource;
  final JobTitleLocalDataSource _localDataSource;

  CreateJobRepositoryImpl({
    required CreateJobRemoteDataSource remoteDataSource,
    required JobTitleLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, bool>> createJob(CreateJobEntity job) async {
    try {
      final request = CreateJobRequestModel.fromEntity(job);
      final response = await _remoteDataSource.createJob(request);

      if (response.success) {
        return const Right(true);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on ServerException catch (e) {
      dev.log('Server exception in createJob: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in createJob: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in createJob',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateJob({
    required String jobId,
    required CreateJobEntity job,
  }) async {
    try {
      if (jobId.trim().isEmpty) {
        return const Left(ValidationFailure(message: 'Job ID is required'));
      }

      final request = CreateJobRequestModel.fromEntity(job);
      final response = await _remoteDataSource.updateJob(
        jobId: jobId,
        request: request,
      );

      if (response.success) {
        return const Right(true);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on ServerException catch (e) {
      dev.log('Server exception in updateJob: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in updateJob: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in updateJob',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JobTitleEntity>>> getJobTitles() async {
    try {
      // Try to get from cache first
      try {
        final cachedTitles = await _localDataSource.getCachedJobTitles();
        if (cachedTitles.isNotEmpty) {
          dev.log('Using cached job titles');
          return Right(cachedTitles);
        }
      } on CacheException {
        dev.log('Cache miss or expired, fetching from remote');
      }

      // Fetch from remote
      final response = await _remoteDataSource.getJobTitles();

      if (response.success && response.jobTitles.isNotEmpty) {
        // Cache the results
        try {
          await _localDataSource.cacheJobTitles(response.jobTitles);
        } on CacheException catch (e) {
          dev.log('Failed to cache job titles: ${e.message}');
          // Don't fail the operation if caching fails
        }

        return Right(response.jobTitles);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getJobTitles: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getJobTitles: ${e.message}');

      // Try to return cached data as fallback
      try {
        final cachedTitles = await _localDataSource.getCachedJobTitles();
        dev.log('Network error, using cached job titles as fallback');
        return Right(cachedTitles);
      } on CacheException {
        return Left(NetworkFailure(message: e.message));
      }
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getJobTitles',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createJobTitle(String title) async {
    try {
      if (title.trim().isEmpty) {
        return const Left(ValidationFailure(message: 'Title cannot be empty'));
      }

      final response = await _remoteDataSource.createJobTitle(title.trim());

      if (response.success) {
        // Clear cache to force refresh on next request
        try {
          await _localDataSource.clearJobTitlesCache();
        } on CacheException catch (e) {
          dev.log('Failed to clear job titles cache: ${e.message}');
          // Don't fail the operation if cache clearing fails
        }

        return const Right(true);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on ServerException catch (e) {
      dev.log('Server exception in createJobTitle: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in createJobTitle: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in createJobTitle',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CompanySelectionEntity>>>
  getUserCompanies() async {
    try {
      final companies = await _remoteDataSource.getUserCompanies();
      return Right(companies);
    } on ServerException catch (e) {
      dev.log('Server exception in getUserCompanies: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getUserCompanies: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getUserCompanies',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateJobData(CreateJobEntity job) async {
    try {
      // This could be extended to include server-side validation
      // For now, we'll just return success as validation is done in use cases
      return const Right(true);
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in validateJobData',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
