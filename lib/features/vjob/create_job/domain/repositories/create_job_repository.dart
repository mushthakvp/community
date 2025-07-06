import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/create_job_entity.dart';
import '../entities/job_title_entity.dart';

abstract class CreateJobRepository {
  Future<Either<Failure, List<JobTitleEntity>>> getJobTitles();
  Future<Either<Failure, bool>> createJobTitle(String title);
  Future<Either<Failure, bool>> createJob(CreateJobEntity job);
  Future<Either<Failure, bool>> updateJob(CreateJobEntity job);
}
