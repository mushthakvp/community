import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/create_job_entity.dart';
import '../entities/job_validation_entity.dart';
import '../repositories/create_job_repository.dart';

class CreateJobUseCase {
  final CreateJobRepository repository;

  CreateJobUseCase(this.repository);

  Future<Either<Failure, bool>> call(CreateJobEntity job) async {
    // Validate job data
    final validation = JobValidationEntity.fromJob(job);
    if (!validation.isValid) {
      return Left(ValidationFailure(message: validation.errors.first));
    }

    return await repository.createJob(job);
  }
}
