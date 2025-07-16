import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../domain/entities/ad_entity.dart';
import '../../domain/entities/ads_filter_entity.dart';
import '../../domain/entities/ads_response_entity.dart';
import '../../domain/repositories/ads_repository.dart';
import '../datasources/ads_local_data_source.dart';
import '../datasources/ads_remote_data_source.dart';
import '../models/ad_model.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource remoteDataSource;
  final AdsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AdsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AdsResponseEntity>> getAds({
    required int page,
    required int limit,
    AdsFilterEntity? filter,
  }) async {
    final cacheKey = _generateCacheKey(page, limit, filter);

    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getAds(
          page: page,
          limit: limit,
          filter: filter,
        );

        // Cache the first page or if cache is empty
        if (page == 1) {
          await localDataSource.cacheAds(
            cacheKey,
            remoteData.ads.cast<AdModel>(),
          );
        }

        // Cache individual ads for details page
        for (final ad in remoteData.ads) {
          await localDataSource.cacheAd(ad as AdModel);
        }

        return Right(remoteData);
      } on ServerException catch (e) {
        // Try to return cached data on server error
        try {
          final localData = await localDataSource.getCachedAds(cacheKey);
          if (localData.isNotEmpty) {
            dev.log('Returning cached data due to server error');
            return Right(
              AdsResponseEntity(
                ads: localData,
                totalCount: localData.length,
                currentPage: page,
                totalPages: 1,
                hasNextPage: false,
                hasPreviousPage: false,
              ),
            );
          }
        } on CacheException {
          // No cached data available
        }
        return Left(ServerFailure(message: e.message));
      } on Exception catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // No internet connection, try to return cached data
      try {
        final localData = await localDataSource.getCachedAds(cacheKey);
        return Right(
          AdsResponseEntity(
            ads: localData,
            totalCount: localData.length,
            currentPage: page,
            totalPages: 1,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        );
      } on CacheException {
        return const Left(
          NetworkFailure(
            message: 'No internet connection and no cached data available',
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, AdEntity>> getAdById(String adId) async {
    // First try to get from cache
    try {
      final cachedAd = await localDataSource.getCachedAdById(adId);
      if (cachedAd != null) {
        dev.log('Returning cached ad: $adId');

        // Add to recently viewed
        await localDataSource.addToRecentlyViewed(cachedAd);

        return Right(cachedAd);
      }
    } on CacheException {
      // Continue to remote fetch
    }

    // If not in cache and we have internet, fetch from remote
    if (await networkInfo.isConnected) {
      try {
        final remoteAd = await remoteDataSource.getAdById(adId);

        // Cache the ad
        await localDataSource.cacheAd(remoteAd);

        // Add to recently viewed
        await localDataSource.addToRecentlyViewed(remoteAd);

        return Right(remoteAd);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on Exception catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(
        NetworkFailure(message: 'No internet connection and ad not cached'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String adId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.toggleFavorite(adId);

        // Update local cache
        if (result) {
          // Refresh favorite ads cache
          try {
            final favoriteAds = await remoteDataSource.getFavoriteAds();
            await localDataSource.saveFavoriteAds(favoriteAds);
          } catch (e) {
            dev.log('Failed to update favorite ads cache: $e');
          }
        }

        return Right(result);
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
  Future<Either<Failure, List<AdEntity>>> getFavoriteAds() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getFavoriteAds();

        // Cache favorite ads
        await localDataSource.saveFavoriteAds(remoteData);

        return Right(remoteData);
      } on ServerException catch (e) {
        // Try to return cached favorite ads
        try {
          final localData = await localDataSource.getFavoriteAds();
          dev.log('Returning cached favorite ads due to server error');
          return Right(localData);
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      } on Exception catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // No internet, return cached favorite ads
      try {
        final localData = await localDataSource.getFavoriteAds();
        return Right(localData);
      } on CacheException {
        return const Left(
          NetworkFailure(
            message: 'No internet connection and no cached favorite ads',
          ),
        );
      }
    }
  }

  @override
  Future<Either<Failure, List<AdEntity>>> getRecentlyViewedAds() async {
    try {
      final localData = await localDataSource.getRecentlyViewedAds();
      return Right(localData);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on Exception catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addToRecentlyViewed(String adId) async {
    try {
      // First get the ad details
      final adResult = await getAdById(adId);

      return adResult.fold((failure) => Left(failure), (ad) async {
        try {
          await localDataSource.addToRecentlyViewed(ad as AdModel);
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

  String _generateCacheKey(int page, int limit, AdsFilterEntity? filter) {
    final filterHash = filter?.hashCode.toString() ?? 'no_filter';
    return 'ads_page_${page}_limit_${limit}_filter_$filterHash';
  }
}
