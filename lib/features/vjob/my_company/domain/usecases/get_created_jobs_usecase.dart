import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/created_job_entity.dart';
import '../repositories/my_company_repository.dart';

class GetCreatedJobsUseCase
    implements UseCase<List<CreatedJobEntity>, GetCreatedJobsParams> {
  final MyCompanyRepository repository;

  GetCreatedJobsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CreatedJobEntity>>> call(
    GetCreatedJobsParams params,
  ) async {
    return await repository.getCreatedJobs(
      companyId: params.companyId,
      status: params.status,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetCreatedJobsParams extends Equatable {
  final String companyId;
  final String status;
  final int page;
  final int limit;

  const GetCreatedJobsParams({
    required this.companyId,
    required this.status,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [companyId, status, page, limit];
}
