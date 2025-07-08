import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/company_job_repository.dart';

class MarkJobAsClosedUseCase implements UseCase<bool, MarkJobAsClosedParams> {
  final CompanyJobRepository repository;

  MarkJobAsClosedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(MarkJobAsClosedParams params) async {
    return await repository.markJobAsClosed(params.jobId);
  }
}

class MarkJobAsClosedParams extends Equatable {
  final String jobId;

  const MarkJobAsClosedParams({required this.jobId});

  @override
  List<Object> get props => [jobId];
}
