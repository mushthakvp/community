import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/create_job_entity.dart';
import '../entities/job_validation_entity.dart';

class ValidateJobUseCase {
  ValidateJobUseCase();

  Either<Failure, JobValidationEntity> call(CreateJobEntity job) {
    try {
      final validation = JobValidationEntity.fromJob(job);
      return Right(validation);
    } catch (e) {
      return Left(ValidationFailure(message: e.toString()));
    }
  }
}
