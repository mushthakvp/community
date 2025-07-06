import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/job_entity.dart';
import '../repositories/vjob_repository.dart';

class CreateJobUseCase {
  final VJobRepository repository;

  CreateJobUseCase(this.repository);

  Future<Either<Failure, JobEntity>> call(CreateJobParams params) async {
    if (params.title.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Job title is required'));
    }
    if (params.description.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Job description is required'),
      );
    }
    if (params.companyId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Company is required'));
    }

    return await repository.createJob(params);
  }
}
