import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/created_job_entity.dart';
import '../../domain/entities/job_candidate_entity.dart';
import '../../domain/repositories/my_company_repository.dart';
import '../datasources/my_company_local_datasource.dart';
import '../datasources/my_company_remote_datasource.dart';

class MyCompanyRepositoryImpl implements MyCompanyRepository {
  final MyCompanyRemoteDataSource remoteDataSource;
  final MyCompanyLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MyCompanyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CompanyEntity>> getMyCompany() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyCompany();
        if (result.companies.isNotEmpty) {
          await localDataSource.cacheCompany(result.companies.first);
          return Right(result.companies.first);
        } else {
          return const Left(ServerFailure(message: 'No company found'));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedCompany = await localDataSource.getCachedCompany();
        if (cachedCompany != null) {
          return Right(cachedCompany);
        } else {
          return const Left(CacheFailure(message: 'No cached company found'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<CreatedJobEntity>>> getCreatedJobs({
    required String companyId,
    required String status,
    required int page,
    required int limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCreatedJobs(
          companyId: companyId,
          status: status,
          page: page,
          limit: limit,
        );

        // Cache only the first page
        if (page == 1) {
          await localDataSource.cacheJobs(companyId, result.jobs);
        }

        return Right(result.jobs);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedJobs = await localDataSource.getCachedJobs(companyId);
        return Right(cachedJobs);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<JobCandidateEntity>>> getJobCandidates({
    required String jobId,
    required int page,
    required int limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getJobCandidates(
          jobId: jobId,
          page: page,
          limit: limit,
        );
        return Right(result.candidates);
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
  Future<Either<Failure, bool>> markJobAsClosed(String jobId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.markJobAsClosed(jobId);
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
