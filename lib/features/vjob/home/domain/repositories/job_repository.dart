import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/job_entity.dart';

abstract class JobRepository {
  Future<Either<Failure, List<JobEntity>>> getJobs({
    int page = 1,
    int limit = 10,
    String? search,
  });

  Future<Either<Failure, JobEntity>> getJobDetails(String jobId);

  Future<Either<Failure, bool>> saveJob(String jobId);

  Future<Either<Failure, bool>> applyJob({
    required String jobId,
    required String resume,
  });

  Future<Either<Failure, List<JobEntity>>> searchJobs({
    required String query,
    int page = 1,
    int limit = 10,
  });
}
