import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/saved_ad_entity.dart';
import '../../domain/repositories/saved_ads_repository.dart';
import '../datasources/saved_ads_local_datasource.dart';
import '../datasources/saved_ads_remote_datasource.dart';

class SavedAdsRepositoryImpl implements SavedAdsRepository {
  final SavedAdsRemoteDataSource remoteDataSource;
  final SavedAdsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SavedAdsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SavedAdEntity>>> getSavedAds() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAds = await remoteDataSource.getSavedAds();
        await localDataSource.cacheSavedAds(remoteAds);
        return Right(remoteAds);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      try {
        final cachedAds = await localDataSource.getCachedSavedAds();
        return Right(cachedAds);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String adId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.toggleFavorite(adId);
        await localDataSource.clearCache();
        return const Right(null);
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
