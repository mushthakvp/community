import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/job_details_repository.dart';

class SaveJobUseCase implements UseCase<bool, SaveJobParams> {
  final JobDetailsRepository repository;

  SaveJobUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveJobParams params) async {
    return await repository.saveJob(params.jobId);
  }
}

class SaveJobParams extends Equatable {
  final String jobId;

  const SaveJobParams({required this.jobId});

  @override
  List<Object> get props => [jobId];
}
