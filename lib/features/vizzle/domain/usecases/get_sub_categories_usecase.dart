import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/vizzle_entities.dart';
import '../repositories/vizzle_repository.dart';

class GetSubCategoriesUseCase {
  final VizzleRepository repository;

  GetSubCategoriesUseCase(this.repository);

  Future<Either<Failure, List<SubCategoryEntity>>> call(
    String categoryId,
  ) async {
    if (categoryId.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Category ID cannot be empty'),
      );
    }
    return await repository.getSubCategories(categoryId);
  }
}
