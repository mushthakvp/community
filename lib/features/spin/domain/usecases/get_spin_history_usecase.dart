import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/spin_history_entity.dart';
import '../repositories/spin_repository.dart';

class GetSpinHistoryUseCase {
  final SpinRepository repository;

  GetSpinHistoryUseCase(this.repository);

  Future<Either<Failure, List<SpinHistoryEntity>>> call({
    int page = 1,
    int limit = 10,
  }) async {
    if (page < 1) {
      return const Left(
        ValidationFailure(message: 'Page must be greater than 0'),
      );
    }
    if (limit < 1 || limit > 100) {
      return const Left(
        ValidationFailure(message: 'Limit must be between 1 and 100'),
      );
    }
    return await repository.getSpinHistory(page: page, limit: limit);
  }
}
