import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/my_job_entity.dart';
import '../repositories/my_jobs_repository.dart';

class UpdateJobStatusUseCase implements UseCase<bool, UpdateJobStatusParams> {
  final MyJobsRepository repository;

  UpdateJobStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateJobStatusParams params) async {
    // Validate parameters
    if (params.jobId.isEmpty) {
      return const Left(ValidationFailure(message: 'Job ID cannot be empty'));
    }

    switch (params.action) {
      case JobAction.remove:
        return await repository.removeJob(params.jobId);
      case JobAction.updateStatus:
        if (params.newStatus == null) {
          return const Left(
            ValidationFailure(
              message: 'New status is required for update action',
            ),
          );
        }
        return await repository.updateJobStatus(
          jobId: params.jobId,
          status: params.newStatus!,
        );
    }
  }
}

/// Parameters for UpdateJobStatusUseCase
class UpdateJobStatusParams extends Equatable {
  final String jobId;
  final JobAction action;
  final MyJobStatus? newStatus;

  const UpdateJobStatusParams({
    required this.jobId,
    required this.action,
    this.newStatus,
  });

  /// Factory constructor for removing a job
  const UpdateJobStatusParams.remove(String jobId)
    : this(jobId: jobId, action: JobAction.remove, newStatus: null);

  /// Factory constructor for updating job status
  const UpdateJobStatusParams.updateStatus({
    required String jobId,
    required MyJobStatus newStatus,
  }) : this(jobId: jobId, action: JobAction.updateStatus, newStatus: newStatus);

  @override
  List<Object?> get props => [jobId, action, newStatus];

  @override
  String toString() =>
      'UpdateJobStatusParams(jobId: $jobId, action: $action, newStatus: $newStatus)';
}

enum JobAction { remove, updateStatus }
