import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/create_job_entity.dart';
import '../entities/job_validation_entity.dart';
import '../repositories/create_job_repository.dart';

class UpdateJobUseCase {
  final CreateJobRepository repository;

  UpdateJobUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String jobId,
    required CreateJobEntity job,
  }) async {
    if (jobId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Job ID is required'));
    }

    // Validate job data
    final validation = JobValidationEntity.fromJob(job);
    if (!validation.isValid) {
      return Left(ValidationFailure(message: validation.errors.first));
    }

    return await repository.updateJob(jobId: jobId, job: job);
  }
}
