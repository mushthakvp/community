import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/company_entity.dart';
import '../repositories/my_company_repository.dart';

class GetCompanyUseCase implements UseCase<CompanyEntity, NoParams> {
  final MyCompanyRepository repository;

  GetCompanyUseCase(this.repository);

  @override
  Future<Either<Failure, CompanyEntity>> call(NoParams params) async {
    return await repository.getMyCompany();
  }
}
