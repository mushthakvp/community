import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/vizzle_entities.dart';
import '../repositories/vizzle_repository.dart';

class GetSubItemsUseCase {
  final VizzleRepository repository;

  GetSubItemsUseCase(this.repository);

  Future<Either<Failure, List<SubItemEntity>>> call(
    String subSubCategoryId,
  ) async {
    if (subSubCategoryId.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Sub Sub Category ID cannot be empty'),
      );
    }
    return await repository.getSubItems(subSubCategoryId);
  }
}
