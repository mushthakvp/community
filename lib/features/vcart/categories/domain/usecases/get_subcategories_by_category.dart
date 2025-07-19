import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/subcategory.dart';
import '../repositories/categories_repository.dart';

class GetSubCategoriesByCategory
    implements UseCase<List<SubCategory>, GetSubCategoriesByCategoryParams> {
  final CategoriesRepository repository;

  GetSubCategoriesByCategory(this.repository);

  @override
  Future<Either<Failure, List<SubCategory>>> call(
    GetSubCategoriesByCategoryParams params,
  ) async {
    return await repository.getSubCategoriesByCategory(
      categoryId: params.categoryId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetSubCategoriesByCategoryParams {
  final String categoryId;
  final int page;
  final int limit;
  final bool isLoadMore;

  const GetSubCategoriesByCategoryParams({
    required this.categoryId,
    this.page = 1,
    this.limit = 10,
    this.isLoadMore = false,
  });
}
