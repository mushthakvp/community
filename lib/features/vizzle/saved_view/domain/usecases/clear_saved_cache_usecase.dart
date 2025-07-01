import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/saved_ads_repository.dart';

class ClearSavedCacheUseCase implements UseCase<void, NoParams> {
  final SavedAdsRepository repository;

  ClearSavedCacheUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearCache();
  }
}
