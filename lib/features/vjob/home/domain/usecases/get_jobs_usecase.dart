import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/home_job_entity.dart';
import '../repositories/vjob_home_repository.dart';

class GetJobsUseCase implements UseCase<List<HomeJobEntity>, GetJobsParams> {
  final VJobHomeRepository repository;

  GetJobsUseCase(this.repository);

  @override
  Future<Either<Failure, List<HomeJobEntity>>> call(
    GetJobsParams params,
  ) async {
    return await repository.getJobs(page: params.page, limit: params.limit);
  }
}

class GetJobsParams extends Equatable {
  final int page;
  final int limit;

  const GetJobsParams({required this.page, required this.limit});

  @override
  List<Object> get props => [page, limit];
}
