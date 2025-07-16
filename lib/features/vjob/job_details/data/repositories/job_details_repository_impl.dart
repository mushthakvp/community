import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/apply_job_entity.dart';
import '../../domain/entities/job_details_entity.dart';
import '../../domain/repositories/job_details_repository.dart';
import '../datasources/job_details_local_datasource.dart';
import '../datasources/job_details_remote_datasource.dart';

class JobDetailsRepositoryImpl implements JobDetailsRepository {
  final JobDetailsRemoteDataSource remoteDataSource;
  final JobDetailsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  JobDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, JobDetailsEntity>> getJobDetails(String jobId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getJobDetails(jobId);
        await localDataSource.cacheJobDetails(jobId, result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedJobDetails = await localDataSource.getCachedJobDetails(
          jobId,
        );
        if (cachedJobDetails != null) {
          return Right(cachedJobDetails);
        } else {
          return const Left(CacheFailure(message: 'No cached data available'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, ApplyJobEntity>> applyJob({
    required String jobId,
    required String resumeUrl,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.applyJob(
          jobId: jobId,
          resumeUrl: resumeUrl,
        );
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
  Future<Either<Failure, bool>> saveJob(String jobId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.saveJob(jobId);
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
