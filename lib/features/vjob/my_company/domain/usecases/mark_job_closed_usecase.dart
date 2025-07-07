import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/my_company_repository.dart';

class MarkJobClosedUseCase implements UseCase<bool, MarkJobClosedParams> {
  final MyCompanyRepository repository;

  MarkJobClosedUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(MarkJobClosedParams params) async {
    return await repository.markJobAsClosed(params.jobId);
  }
}

class MarkJobClosedParams extends Equatable {
  final String jobId;

  const MarkJobClosedParams({required this.jobId});

  @override
  List<Object> get props => [jobId];
}
