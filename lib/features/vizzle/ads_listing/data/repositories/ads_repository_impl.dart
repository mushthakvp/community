import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/ad_entity.dart';
import '../../domain/entities/ads_filter_entity.dart';
import '../../domain/entities/ads_response_entity.dart';
import '../../domain/repositories/ads_repository.dart';
import '../datasources/ads_remote_data_source.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AdsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AdsResponseEntity>> getAds({
    required int page,
    required int limit,
    AdsFilterEntity? filter,
  }) async {
    try {
      final remoteData = await remoteDataSource.getAds(
        page: page,
        limit: limit,
        filter: filter,
      );

      return Right(remoteData);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdEntity>> getAdById(String adId) async {
    // First try to get from cache
    try {
      final cachedAd = await remoteDataSource.getAdById(adId);
      return Right(cachedAd);
    } on CacheException {
      // Continue to remote fetch
    }
    try {
      final remoteAd = await remoteDataSource.getAdById(adId);
      return Right(remoteAd);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String adId) async {
    try {
      final result = await remoteDataSource.toggleFavorite(adId);
      if (result) {
        await remoteDataSource.getFavoriteAds();
      }
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdEntity>>> getFavoriteAds() async {
    try {
      final remoteData = await remoteDataSource.getFavoriteAds();
      return Right(remoteData);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdEntity>>> getRecentlyViewedAds() async {
    try {
      return Right([]);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addToRecentlyViewed(String adId) async {
    try {
      final adResult = await getAdById(adId);
      return adResult.fold((failure) => Left(failure), (ad) async {
        try {
          return const Right(true);
        } on CacheException catch (e) {
          return Left(CacheFailure(message: e.message));
        }
      });
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getLocations() async {
    if (await networkInfo.isConnected) {
      try {
        final locations = await remoteDataSource.getLocations();
        return Right(locations);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on Exception catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<String>>>> getFilterOptions() async {
    if (await networkInfo.isConnected) {
      try {
        final filterOptions = await remoteDataSource.getFilterOptions();
        return Right(filterOptions);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on Exception catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
