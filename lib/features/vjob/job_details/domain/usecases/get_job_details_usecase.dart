import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/job_details_entity.dart';
import '../repositories/job_details_repository.dart';

class GetJobDetailsUseCase
    implements UseCase<JobDetailsEntity, GetJobDetailsParams> {
  final JobDetailsRepository repository;

  GetJobDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, JobDetailsEntity>> call(
    GetJobDetailsParams params,
  ) async {
    return await repository.getJobDetails(params.jobId);
  }
}

class GetJobDetailsParams extends Equatable {
  final String jobId;

  const GetJobDetailsParams({required this.jobId});

  @override
  List<Object> get props => [jobId];
}
