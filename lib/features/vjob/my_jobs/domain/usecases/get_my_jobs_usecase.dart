import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/my_job_entity.dart';
import '../repositories/my_jobs_repository.dart';

class GetMyJobsUseCase implements UseCase<MyJobsResult, GetMyJobsParams> {
  final MyJobsRepository repository;

  GetMyJobsUseCase(this.repository);

  @override
  Future<Either<Failure, MyJobsResult>> call(GetMyJobsParams params) async {
    if (params.page < 1) {
      return const Left(
        ValidationFailure(message: 'Page number must be greater than 0'),
      );
    }

    if (params.limit < 1 || params.limit > 100) {
      return const Left(
        ValidationFailure(message: 'Limit must be between 1 and 100'),
      );
    }

    return await repository.getMyJobs(
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetMyJobsParams extends Equatable {
  final MyJobStatus status;
  final int page;
  final int limit;

  const GetMyJobsParams({
    required this.status,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [status, page, limit];

  @override
  String toString() =>
      'GetMyJobsParams(status: $status, page: $page, limit: $limit)';
}
