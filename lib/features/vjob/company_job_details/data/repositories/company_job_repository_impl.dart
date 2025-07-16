import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/candidate_entity.dart';
import '../../domain/entities/company_job_entity.dart';
import '../../domain/repositories/company_job_repository.dart';
import '../datasources/company_job_local_datasource.dart';
import '../datasources/company_job_remote_datasource.dart';

class CompanyJobRepositoryImpl implements CompanyJobRepository {
  final CompanyJobRemoteDataSource remoteDataSource;
  final CompanyJobLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CompanyJobRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CompanyJobEntity>> getJobDetails(String jobId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getJobDetails(jobId);

        // Cache the job details
        await localDataSource.cacheJobDetails(result.job);

        return Right(result.job);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedJob = await localDataSource.getCachedJobDetails(jobId);
        if (cachedJob != null) {
          return Right(cachedJob);
        } else {
          return const Left(
            CacheFailure(message: 'No cached job details found'),
          );
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> getJobCandidates({
    required String jobId,
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getJobCandidates(
          jobId: jobId,
          page: page,
          limit: limit,
        );

        // Cache only the first page
        if (page == 1) {
          await localDataSource.cacheCandidates(jobId, result.candidates);
        }

        return Right(result.candidates);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedCandidates = await localDataSource.getCachedCandidates(
          jobId,
        );
        return Right(cachedCandidates);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> markJobAsClosed(String jobId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.markJobAsClosed(jobId);

        // Clear cache for this job since it's now closed
        await localDataSource.clearCacheForJob(jobId);

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> reapplyJob(String jobId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.reapplyJob(jobId);

        // Clear cache for this job since its status changed
        await localDataSource.clearCacheForJob(jobId);

        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> downloadCandidateCV(
    String candidateId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.downloadCandidateCV(candidateId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
