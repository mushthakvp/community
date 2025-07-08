import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/company_entity.dart';
import '../repositories/create_company_repository.dart';

class CreateCompanyUseCase
    implements UseCase<CompanyEntity, CreateCompanyParams> {
  final CreateCompanyRepository repository;

  CreateCompanyUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyEntity>> call(
    CreateCompanyParams params,
  ) async {
    return await repository.createCompany(params.company);
  }
}

class CreateCompanyParams extends Equatable {
  final CompanyEntity company;

  const CreateCompanyParams({required this.company});

  @override
  List<Object> get props => [company];
}
