import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/recently_viewed_ad_entity.dart';
import '../../domain/repositories/recently_viewed_repository.dart';
import '../datasources/recently_viewed_local_datasource.dart';
import '../datasources/recently_viewed_remote_datasource.dart';

class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  final RecentlyViewedRemoteDataSource remoteDataSource;
  final RecentlyViewedLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RecentlyViewedRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<RecentlyViewedAdEntity>>>
  getRecentlyViewedAds() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAds = await remoteDataSource.getRecentlyViewedAds();
        await localDataSource.cacheRecentlyViewedAds(remoteAds);
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
        final cachedAds = await localDataSource.getCachedRecentlyViewedAds();
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
  Future<Either<Failure, void>> clearRecentlyViewed() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.clearRecentlyViewed();
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
