import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/company_selection_entity.dart';
import '../entities/create_job_entity.dart';
import '../entities/job_title_entity.dart';

abstract class CreateJobRepository {
  /// Creates a new job posting
  Future<Either<Failure, bool>> createJob(CreateJobEntity job);

  /// Updates an existing job posting
  Future<Either<Failure, bool>> updateJob({
    required String jobId,
    required CreateJobEntity job,
  });

  /// Gets all available job titles for suggestions
  Future<Either<Failure, List<JobTitleEntity>>> getJobTitles();

  /// Creates a new job title
  Future<Either<Failure, bool>> createJobTitle(String title);

  /// Gets user's companies for selection
  Future<Either<Failure, List<CompanySelectionEntity>>> getUserCompanies();

  /// Validates job data before submission
  Future<Either<Failure, bool>> validateJobData(CreateJobEntity job);
}
