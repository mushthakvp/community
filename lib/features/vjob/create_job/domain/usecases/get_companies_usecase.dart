import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/company_selection_entity.dart';
import '../repositories/create_job_repository.dart';

class GetCompaniesUseCase {
  final CreateJobRepository repository;

  GetCompaniesUseCase(this.repository);

  Future<Either<Failure, List<CompanySelectionEntity>>> call() async {
    return await repository.getUserCompanies();
  }
}
