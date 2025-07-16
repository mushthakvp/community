import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/recently_viewed_repository.dart';

class ClearRecentlyViewedCacheUseCase implements UseCase<void, NoParams> {
  final RecentlyViewedRepository repository;

  ClearRecentlyViewedCacheUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearCache();
  }
}
