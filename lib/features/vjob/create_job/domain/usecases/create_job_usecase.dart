import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/create_job_entity.dart';
import '../repositories/create_job_repository.dart';

class CreateJobUseCase implements UseCase<bool, CreateJobParams> {
  final CreateJobRepository repository;

  CreateJobUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CreateJobParams params) async {
    return await repository.createJob(params.job);
  }
}

class CreateJobParams extends Equatable {
  final CreateJobEntity job;

  const CreateJobParams({required this.job});

  @override
  List<Object> get props => [job];
}
