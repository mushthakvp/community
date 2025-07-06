import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/create_job_entity.dart';
import '../../domain/entities/job_title_entity.dart';
import '../../domain/repositories/create_job_repository.dart';
import '../datasources/create_job_local_datasource.dart';
import '../datasources/create_job_remote_datasource.dart';
import '../models/create_job_model.dart';

class CreateJobRepositoryImpl implements CreateJobRepository {
  final CreateJobRemoteDataSource remoteDataSource;
  final CreateJobLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CreateJobRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<JobTitleEntity>>> getJobTitles() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getJobTitles();
        await localDataSource.cacheJobTitles(result.jobTitles);
        return Right(result.jobTitles);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedTitles = await localDataSource.getCachedJobTitles();
        return Right(cachedTitles);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createJobTitle(String title) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.createJobTitle(title);
        if (result) {
          // Clear cache to refresh job titles
          await localDataSource.clearCache();
        }
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
  Future<Either<Failure, bool>> createJob(CreateJobEntity job) async {
    if (await networkInfo.isConnected) {
      try {
        final jobModel = CreateJobModel.fromEntity(job);
        final result = await remoteDataSource.createJob(jobModel);
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
  Future<Either<Failure, bool>> updateJob(CreateJobEntity job) async {
    if (await networkInfo.isConnected) {
      try {
        final jobModel = CreateJobModel.fromEntity(job);
        final result = await remoteDataSource.updateJob(jobModel);
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
