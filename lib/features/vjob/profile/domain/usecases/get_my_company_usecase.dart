import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/my_company_entity.dart';
import '../repositories/profile_repository.dart';

class GetMyCompanyUseCase {
  final ProfileRepository repository;

  GetMyCompanyUseCase(this.repository);

  Future<Either<Failure, MyCompanyEntity?>> call() async {
    return await repository.getMyCompany();
  }
}
