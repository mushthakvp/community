import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/apply_job_entity.dart';
import '../entities/job_details_entity.dart';

abstract class JobDetailsRepository {
  Future<Either<Failure, JobDetailsEntity>> getJobDetails(String jobId);
  Future<Either<Failure, ApplyJobEntity>> applyJob({
    required String jobId,
    required String resumeUrl,
  });
  Future<Either<Failure, bool>> saveJob(String jobId);
}
