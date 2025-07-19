import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/profile_data.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_data_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileData>> getProfileData() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteData = await remoteDataSource.getProfileData();
          await localDataSource.cacheProfileData(remoteData);
          return Right(remoteData);
        } catch (e) {
          final cachedData = await localDataSource.getCachedProfileData();
          if (cachedData != null) {
            return Right(cachedData);
          } else {
            return Left(_handleException(e));
          }
        }
      } else {
        final cachedData = await localDataSource.getCachedProfileData();
        if (cachedData != null) {
          return Right(cachedData);
        } else {
          return const Left(
            NetworkFailure(
              message: 'No internet connection and no cached data available',
            ),
          );
        }
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheProfileData(
    ProfileData profileData,
  ) async {
    try {
      await localDataSource.cacheProfileData(profileData as ProfileDataModel);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, ProfileData?>> getCachedProfileData() async {
    try {
      final cachedData = await localDataSource.getCachedProfileData();
      return Right(cachedData);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }
}
