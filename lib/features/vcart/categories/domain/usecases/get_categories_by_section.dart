import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/categories_repository.dart';

class GetCategoriesBySection
    implements UseCase<List<CategoryItem>, GetCategoriesBySectionParams> {
  final CategoriesRepository repository;

  GetCategoriesBySection(this.repository);

  @override
  Future<Either<Failure, List<CategoryItem>>> call(
    GetCategoriesBySectionParams params,
  ) async {
    return await repository.getCategoriesBySection(
      sectionId: params.sectionId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCategoriesBySectionParams {
  final String sectionId;
  final int page;
  final int limit;

  const GetCategoriesBySectionParams({
    required this.sectionId,
    this.page = 1,
    this.limit = 1000,
  });
}
