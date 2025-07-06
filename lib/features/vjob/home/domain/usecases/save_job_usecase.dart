import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/job_repository.dart';

class SaveJobUseCase {
  final JobRepository repository;

  SaveJobUseCase(this.repository);

  Future<Either<Failure, bool>> call(String jobId) async {
    return await repository.saveJob(jobId);
  }
}
