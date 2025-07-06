import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/create_job_repository.dart';

class CreateJobTitleUseCase implements UseCase<bool, CreateJobTitleParams> {
  final CreateJobRepository repository;

  CreateJobTitleUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(CreateJobTitleParams params) async {
    return await repository.createJobTitle(params.title);
  }
}

class CreateJobTitleParams extends Equatable {
  final String title;

  const CreateJobTitleParams({required this.title});

  @override
  List<Object> get props => [title];
}
