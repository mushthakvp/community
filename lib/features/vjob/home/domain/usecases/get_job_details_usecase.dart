import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/job_entity.dart';
import '../repositories/job_repository.dart';

class GetJobDetailsUseCase {
  final JobRepository repository;

  GetJobDetailsUseCase(this.repository);

  Future<Either<Failure, JobEntity>> call(String jobId) async {
    return await repository.getJobDetails(jobId);
  }
}
