import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/job_entity.dart';
import '../repositories/job_repository.dart';

class SearchJobsUseCase {
  final JobRepository repository;

  SearchJobsUseCase(this.repository);

  Future<Either<Failure, List<JobEntity>>> call({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.searchJobs(query: query, page: page, limit: limit);
  }
}
