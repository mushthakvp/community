import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/candidate_entity.dart';
import '../entities/company_job_entity.dart';

abstract class CompanyJobRepository {
  /// Get job details by job ID
  Future<Either<Failure, CompanyJobEntity>> getJobDetails(String jobId);

  /// Get candidates who applied for a specific job
  Future<Either<Failure, List<CandidateEntity>>> getJobCandidates({
    required String jobId,
    int page = 1,
    int limit = 10,
  });

  /// Mark job as closed
  Future<Either<Failure, bool>> markJobAsClosed(String jobId);

  /// Re-apply for a rejected job
  Future<Either<Failure, bool>> reapplyJob(String jobId);

  /// Download candidate's CV/Resume
  Future<Either<Failure, String>> downloadCandidateCV(String candidateId);
}
