import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/vizzle_entities.dart';
import '../../domain/repositories/vizzle_repository.dart';
import '../datasources/vizzle_local_data_source.dart';
import '../datasources/vizzle_remote_data_source.dart';

class VizzleRepositoryImpl implements VizzleRepository {
  final VizzleRemoteDataSource remoteDataSource;
  final VizzleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  VizzleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, VizzleHomeEntity>> getVizzleHome() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getVizzleHome();
        await localDataSource.cacheVizzleHome(remoteData);
        return Right(remoteData.toEntity());
      } on ServerException catch (e) {
        try {
          final localData = await localDataSource.getLastVizzleHome();
          return Right(localData.toEntity());
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      }
    } else {
      try {
        final localData = await localDataSource.getLastVizzleHome();
        return Right(localData.toEntity());
      } on CacheException {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getCategories();
        await localDataSource.cacheCategories(remoteData);
        return Right(
          remoteData.map((category) => category.toEntity()).toList(),
        );
      } on ServerException catch (e) {
        try {
          final localData = await localDataSource.getLastCategories();
          return Right(
            localData.map((category) => category.toEntity()).toList(),
          );
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      }
    } else {
      try {
        final localData = await localDataSource.getLastCategories();
        return Right(localData.map((category) => category.toEntity()).toList());
      } on CacheException {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryById(
    String categoryId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getCategoryById(categoryId);
        return Right(remoteData.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> getSubCategories(
    String categoryId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSubCategories(categoryId);
        return Right(
          remoteData.map((subCategory) => subCategory.toEntity()).toList(),
        );
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SubCategoryEntity>> getSubCategoryById(
    String subCategoryId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSubCategoryById(
          subCategoryId,
        );
        return Right(remoteData.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SubSubCategoryEntity>>> getSubSubCategories(
    String subCategoryId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSubSubCategories(
          subCategoryId,
        );
        return Right(
          remoteData
              .map((subSubCategory) => subSubCategory.toEntity())
              .toList(),
        );
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SubSubCategoryEntity>> getSubSubCategoryById(
    String subSubCategoryId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSubSubCategoryById(
          subSubCategoryId,
        );
        return Right(remoteData.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<SubItemEntity>>> getSubItems(
    String subSubCategoryId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSubItems(subSubCategoryId);
        return Right(remoteData.map((subItem) => subItem.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SubItemEntity>> getSubItemById(
    String subItemId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSubItemById(subItemId);
        return Right(remoteData.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<AdEntity>>> getAds({
    String? categoryId,
    String? subCategoryId,
    String? subSubCategoryId,
    String? subItemId,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getAds(
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          subSubCategoryId: subSubCategoryId,
          subItemId: subItemId,
          searchQuery: searchQuery,
          minPrice: minPrice,
          maxPrice: maxPrice,
          page: page,
          limit: limit,
        );
        return Right(remoteData.map((ad) => ad.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AdEntity>> getAdById(String adId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getAdById(adId);
        return Right(remoteData.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<AdEntity>>> searchAds({
    required String keyword,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.searchAds(
          keyword: keyword,
          categoryId: categoryId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          page: page,
          limit: limit,
        );
        return Right(remoteData.map((ad) => ad.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> addToFavorites(String adId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.addToFavorites(adId);
        await localDataSource.addToFavorites(adId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFromFavorites(String adId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.removeFromFavorites(adId);
        await localDataSource.removeFromFavorites(adId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
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
        return Right(remoteData.map((ad) => ad.toEntity()).toList());
      } on ServerException catch (e) {
        try {
          final localData = await localDataSource.getFavoriteAds();
          return Right(localData.map((ad) => ad.toEntity()).toList());
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      }
    } else {
      try {
        final localData = await localDataSource.getFavoriteAds();
        return Right(localData.map((ad) => ad.toEntity()).toList());
      } on CacheException {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, List<AdEntity>>> getRecentlyViewedAds() async {
    try {
      final localData = await localDataSource.getRecentlyViewedAds();
      return Right(localData.map((ad) => ad.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure(message: 'No recently viewed ads'));
    }
  }

  @override
  Future<Either<Failure, bool>> addToRecentlyViewed(String adId) async {
    try {
      await localDataSource.addToRecentlyViewed(adId);
      return const Right(true);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
