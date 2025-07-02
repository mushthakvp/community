import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/city.dart';
import '../repositories/place_add_repository.dart';

class GetCitiesUseCase implements UseCase<List<City>, NoParams> {
  final PlaceAddRepository repository;

  GetCitiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<City>>> call(NoParams params) async {
    return await repository.getCities();
  }
}
