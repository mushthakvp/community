import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/company_entity.dart';
import '../repositories/create_company_repository.dart';

class UpdateCompanyUseCase
    implements UseCase<CompanyEntity, UpdateCompanyParams> {
  final CreateCompanyRepository repository;

  UpdateCompanyUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyEntity>> call(
    UpdateCompanyParams params,
  ) async {
    return await repository.updateCompany(params.company);
  }
}

class UpdateCompanyParams extends Equatable {
  final CompanyEntity company;

  const UpdateCompanyParams({required this.company});

  @override
  List<Object> get props => [company];
}
