import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/company_entity.dart';

abstract class CreateCompanyRepository {
  Future<Either<Failure, CompanyEntity>> createCompany(CompanyEntity company);
  Future<Either<Failure, CompanyEntity>> updateCompany(CompanyEntity company);
  Future<Either<Failure, String>> uploadImage(String filePath);
  Future<Either<Failure, void>> deleteImage(String imageUrl);
  Future<Either<Failure, CompanyEntity?>> getCachedCompany();
  Future<Either<Failure, void>> cacheCompany(CompanyEntity company);
  Future<Either<Failure, void>> clearCache();
}
