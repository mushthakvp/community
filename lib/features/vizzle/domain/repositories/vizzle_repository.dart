// lib/features/vizzle/domain/repositories/vizzle_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/vizzle_entities.dart';

abstract class VizzleRepository {
  // Home data
  Future<Either<Failure, VizzleHomeEntity>> getVizzleHome();

  // Categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, CategoryEntity>> getCategoryById(String categoryId);

  // Sub categories
  Future<Either<Failure, List<SubCategoryEntity>>> getSubCategories(
    String categoryId,
  );
  Future<Either<Failure, SubCategoryEntity>> getSubCategoryById(
    String subCategoryId,
  );

  // Sub sub categories
  Future<Either<Failure, List<SubSubCategoryEntity>>> getSubSubCategories(
    String subCategoryId,
  );
  Future<Either<Failure, SubSubCategoryEntity>> getSubSubCategoryById(
    String subSubCategoryId,
  );

  // Sub items
  Future<Either<Failure, List<SubItemEntity>>> getSubItems(
    String subSubCategoryId,
  );
  Future<Either<Failure, SubItemEntity>> getSubItemById(String subItemId);

  // Ads
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
  });

  Future<Either<Failure, AdEntity>> getAdById(String adId);

  // Search
  Future<Either<Failure, List<AdEntity>>> searchAds({
    required String keyword,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? limit,
  });

  // Favorites
  Future<Either<Failure, bool>> addToFavorites(String adId);
  Future<Either<Failure, bool>> removeFromFavorites(String adId);
  Future<Either<Failure, List<AdEntity>>> getFavoriteAds();

  // Recently viewed
  Future<Either<Failure, List<AdEntity>>> getRecentlyViewedAds();
  Future<Either<Failure, bool>> addToRecentlyViewed(String adId);
}
