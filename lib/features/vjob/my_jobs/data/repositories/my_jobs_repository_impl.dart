import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/my_job_entity.dart';
import '../../domain/repositories/my_jobs_repository.dart';
import '../datasources/my_jobs_local_datasource.dart';
import '../datasources/my_jobs_remote_datasource.dart';

class MyJobsRepositoryImpl implements MyJobsRepository {
  final MyJobsRemoteDataSource remoteDataSource;
  final MyJobsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MyJobsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MyJobsResult>> getMyJobs({
    required MyJobStatus status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        return await _getJobsFromRemote(status, page, limit);
      } else {
        return await _getJobsFromCache(status);
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateJobStatus({
    required String jobId,
    required MyJobStatus status,
  }) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.updateJobStatus(
          jobId: jobId,
          action: status.value,
        );
        if (result) {
          await _updateLocalJobStatus(jobId, status);
        }
        return Right(result);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeJob(String jobId) async {
    try {
      if (await networkInfo.isConnected) {
        final result = await remoteDataSource.removeJob(jobId);
        if (result) {
          await _removeFromLocalCache(jobId);
        }
        return Right(result);
      } else {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Get jobs from remote data source
  Future<Either<Failure, MyJobsResult>> _getJobsFromRemote(
    MyJobStatus status,
    int page,
    int limit,
  ) async {
    try {
      final response = await remoteDataSource.getMyJobs(
        status: status.value,
        page: page,
        limit: limit,
      );
      final result = response.toDomainResult(page);
      if (page == 1 && result.jobs.isNotEmpty) {
        await localDataSource.cacheJobs(status.value, response.jobs);
      }
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  /// Get jobs from local cache
  Future<Either<Failure, MyJobsResult>> _getJobsFromCache(
    MyJobStatus status,
  ) async {
    try {
      final cachedJobs = await localDataSource.getCachedJobs(status.value);
      if (cachedJobs.isEmpty) {
        return const Left(CacheFailure(message: 'No cached data available'));
      }
      final result = MyJobsResult(
        jobs: cachedJobs,
        total: cachedJobs.length,
        totalPages: 1,
        currentPage: 1,
        hasMoreData: false,
      );
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  Future<void> _updateLocalJobStatus(String jobId, MyJobStatus status) async {
    try {
      final cachedJob = await localDataSource.getCachedJob(jobId);
      if (cachedJob != null) {
        final updatedJob = cachedJob.copyWith(status: status);
        await localDataSource.updateCachedJob(updatedJob);
      }
    } catch (e) {
      debugPrint('Error updating local job status: $e');
    }
  }

  /// Remove job from local cache
  Future<void> _removeFromLocalCache(String jobId) async {
    try {
      for (final status in ['Applied', 'Saved']) {
        await localDataSource.removeCachedJob(jobId, status);
      }
    } catch (e) {
      debugPrint("Error reomved from local cacehe $e");
    }
  }
}
