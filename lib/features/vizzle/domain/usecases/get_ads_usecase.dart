import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/vizzle_entities.dart';
import '../repositories/vizzle_repository.dart';

class GetAdsUseCase {
  final VizzleRepository repository;

  GetAdsUseCase(this.repository);

  Future<Either<Failure, List<AdEntity>>> call({
    String? categoryId,
    String? subCategoryId,
    String? subSubCategoryId,
    String? subItemId,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    return await repository.getAds(
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
  }
}
