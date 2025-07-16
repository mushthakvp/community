import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/candidate_entity.dart';
import '../repositories/company_job_repository.dart';

class GetJobCandidatesUseCase
    implements UseCase<List<CandidateEntity>, GetJobCandidatesParams> {
  final CompanyJobRepository repository;

  GetJobCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(
    GetJobCandidatesParams params,
  ) async {
    return await repository.getJobCandidates(
      jobId: params.jobId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetJobCandidatesParams extends Equatable {
  final String jobId;
  final int page;
  final int limit;

  const GetJobCandidatesParams({
    required this.jobId,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [jobId, page, limit];
}
