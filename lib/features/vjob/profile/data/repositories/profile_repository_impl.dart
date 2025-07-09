import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

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
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getProfile();
        await localDataSource.cacheProfile(result);
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
        final cachedProfile = await localDataSource.getCachedProfile();
        if (cachedProfile != null) {
          return Right(cachedProfile);
        }
        return const Left(CacheFailure(message: 'No cached data available'));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }
}
