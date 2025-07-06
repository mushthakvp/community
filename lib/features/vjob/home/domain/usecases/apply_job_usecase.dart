import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/job_repository.dart';

class ApplyJobUseCase {
  final JobRepository repository;

  ApplyJobUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String jobId,
    required String resume,
  }) async {
    return await repository.applyJob(jobId: jobId, resume: resume);
  }
}
