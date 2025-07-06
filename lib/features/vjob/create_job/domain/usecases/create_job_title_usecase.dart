import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/create_job_repository.dart';

class CreateJobTitleUseCase {
  final CreateJobRepository repository;

  CreateJobTitleUseCase(this.repository);

  Future<Either<Failure, bool>> call(String title) async {
    if (title.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Title cannot be empty'));
    }

    if (title.trim().length < 2) {
      return const Left(
        ValidationFailure(message: 'Title must be at least 2 characters'),
      );
    }

    return await repository.createJobTitle(title.trim());
  }
}
