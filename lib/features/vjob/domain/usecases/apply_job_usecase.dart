import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/vjob_repository.dart';

class ApplyJobUseCase {
  final VJobRepository repository;

  ApplyJobUseCase(this.repository);

  Future<Either<Failure, bool>> call(String jobId, String? resumeUrl) async {
    if (jobId.isEmpty) {
      return const Left(ValidationFailure(message: 'Job ID is required'));
    }
    return await repository.applyForJob(jobId, resumeUrl);
  }
}
