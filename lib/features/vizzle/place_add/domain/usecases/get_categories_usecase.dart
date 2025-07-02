import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/place_add_repository.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  final PlaceAddRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
