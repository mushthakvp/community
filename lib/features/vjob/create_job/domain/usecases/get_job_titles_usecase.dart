import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/job_title_entity.dart';
import '../repositories/create_job_repository.dart';

class GetJobTitlesUseCase implements UseCase<List<JobTitleEntity>, NoParams> {
  final CreateJobRepository repository;

  GetJobTitlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<JobTitleEntity>>> call(NoParams params) async {
    return await repository.getJobTitles();
  }
}
