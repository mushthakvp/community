import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/create_company_repository.dart';
import '../datasources/create_company_local_datasource.dart';
import '../datasources/create_company_remote_datasource.dart';
import '../models/company_model.dart';

class CreateCompanyRepositoryImpl implements CreateCompanyRepository {
  final CreateCompanyRemoteDataSource remoteDataSource;
  final CreateCompanyLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CreateCompanyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CompanyEntity>> createCompany(
    CompanyEntity company,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final companyModel = CompanyModel.fromEntity(company);
        final result = await remoteDataSource.createCompany(companyModel);

        // Cache the created company
        await localDataSource.cacheCompany(result);

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
  Future<Either<Failure, CompanyEntity>> updateCompany(
    CompanyEntity company,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final companyModel = CompanyModel.fromEntity(company);
        final result = await remoteDataSource.updateCompany(companyModel);

        // Cache the updated company
        await localDataSource.cacheCompany(result);

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
  Future<Either<Failure, String>> uploadImage(String filePath) async {
    if (await networkInfo.isConnected) {
      try {
        final imageUrl = await remoteDataSource.uploadImage(filePath);
        return Right(imageUrl);
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
  Future<Either<Failure, void>> deleteImage(String imageUrl) async {
    // Implementation for deleting image from server if needed
    // For now, returning success as it's not implemented in the original code
    return const Right(null);
  }

  @override
  Future<Either<Failure, CompanyEntity?>> getCachedCompany() async {
    try {
      final cachedCompany = await localDataSource.getCachedCompany();
      return Right(cachedCompany);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheCompany(CompanyEntity company) async {
    try {
      final companyModel = CompanyModel.fromEntity(company);
      await localDataSource.cacheCompany(companyModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
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
}
