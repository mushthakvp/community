import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/job_entity.dart';
import '../repositories/vjob_repository.dart';

class GetJobsUseCase {
  final VJobRepository repository;

  GetJobsUseCase(this.repository);

  Future<Either<Failure, List<JobEntity>>> call({
    int page = 1,
    int limit = 10,
    String? search,
    String? location,
    String? workStyle,
  }) async {
    return await repository.getJobs(
      page: page,
      limit: limit,
      search: search,
      location: location,
      workStyle: workStyle,
    );
  }
}
