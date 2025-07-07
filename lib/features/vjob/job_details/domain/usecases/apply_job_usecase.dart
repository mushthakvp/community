import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/apply_job_entity.dart';
import '../repositories/job_details_repository.dart';

class ApplyJobUseCase implements UseCase<ApplyJobEntity, ApplyJobParams> {
  final JobDetailsRepository repository;

  ApplyJobUseCase(this.repository);

  @override
  Future<Either<Failure, ApplyJobEntity>> call(ApplyJobParams params) async {
    return await repository.applyJob(
      jobId: params.jobId,
      resumeUrl: params.resumeUrl,
    );
  }
}

class ApplyJobParams extends Equatable {
  final String jobId;
  final String resumeUrl;

  const ApplyJobParams({required this.jobId, required this.resumeUrl});

  @override
  List<Object> get props => [jobId, resumeUrl];
}
