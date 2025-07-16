import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/vizzle_entities.dart';
import '../repositories/vizzle_repository.dart';

class GetSubSubCategoriesUseCase {
  final VizzleRepository repository;

  GetSubSubCategoriesUseCase(this.repository);

  Future<Either<Failure, List<SubSubCategoryEntity>>> call(
    String subCategoryId,
  ) async {
    if (subCategoryId.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Sub Category ID cannot be empty'),
      );
    }
    return await repository.getSubSubCategories(subCategoryId);
  }
}
