import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/my_company_repository.dart';

class ReapplyJobUseCase implements UseCase<bool, ReapplyJobParams> {
  final MyCompanyRepository repository;

  ReapplyJobUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReapplyJobParams params) async {
    return await repository.reapplyJob(params.jobId);
  }
}

class ReapplyJobParams extends Equatable {
  final String jobId;

  const ReapplyJobParams({required this.jobId});

  @override
  List<Object> get props => [jobId];
}
