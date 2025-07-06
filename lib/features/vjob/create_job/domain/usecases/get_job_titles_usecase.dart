import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/job_title_entity.dart';
import '../repositories/create_job_repository.dart';

class GetJobTitlesUseCase {
  final CreateJobRepository repository;

  GetJobTitlesUseCase(this.repository);

  Future<Either<Failure, List<JobTitleEntity>>> call() async {
    return await repository.getJobTitles();
  }
}
