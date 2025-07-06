import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/create_job_entity.dart';
import '../repositories/create_job_repository.dart';

class UpdateJobUseCase implements UseCase<bool, UpdateJobParams> {
  final CreateJobRepository repository;

  UpdateJobUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateJobParams params) async {
    return await repository.updateJob(params.job);
  }
}

class UpdateJobParams extends Equatable {
  final CreateJobEntity job;

  const UpdateJobParams({required this.job});

  @override
  List<Object> get props => [job];
}
