import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/ads_repository.dart';

class GetFilterOptionsUseCase
    implements UseCase<Map<String, List<String>>, NoParams> {
  final AdsRepository repository;

  GetFilterOptionsUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, List<String>>>> call(
    NoParams params,
  ) async {
    return await repository.getFilterOptions();
  }
}
