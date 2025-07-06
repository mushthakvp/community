import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/my_jobs_entity.dart';
import '../repositories/profile_repository.dart';

class GetMyJobsUseCase {
  final ProfileRepository repository;

  GetMyJobsUseCase(this.repository);

  Future<Either<Failure, List<MyJobsEntity>>> call({
    required String status,
    int page = 1,
    int limit = 10,
  }) async {
    if (status.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Status is required'));
    }

    final validStatuses = ['Applied', 'Saved'];
    if (!validStatuses.contains(status)) {
      return const Left(
        ValidationFailure(message: 'Status must be either Applied or Saved'),
      );
    }

    return await repository.getMyJobs(status: status, page: page, limit: limit);
  }
}
