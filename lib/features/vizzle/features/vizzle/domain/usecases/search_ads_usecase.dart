import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../domain/entities/vizzle_entities.dart';
import '../../../../domain/repositories/vizzle_repository.dart';

class SearchAdsUseCase {
  final VizzleRepository repository;

  SearchAdsUseCase(this.repository);

  Future<Either<Failure, List<AdEntity>>> call({
    required String keyword,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    if (keyword.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Search keyword cannot be empty'),
      );
    }

    return await repository.searchAds(
      keyword: keyword.trim(),
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      page: page,
      limit: limit,
    );
  }
}
