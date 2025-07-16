import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/company_entity.dart';
import '../entities/created_job_entity.dart';
import '../entities/job_candidate_entity.dart';

abstract class MyCompanyRepository {
  Future<Either<Failure, CompanyEntity>> getMyCompany();

  Future<Either<Failure, List<CreatedJobEntity>>> getCreatedJobs({
    required String companyId,
    required String status,
    required int page,
    required int limit,
  });

  Future<Either<Failure, List<JobCandidateEntity>>> getJobCandidates({
    required String jobId,
    required int page,
    required int limit,
  });

  Future<Either<Failure, bool>> reapplyJob(String jobId);

  Future<Either<Failure, bool>> markJobAsClosed(String jobId);
}
