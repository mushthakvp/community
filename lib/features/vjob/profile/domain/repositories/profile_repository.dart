import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/my_company_entity.dart';
import '../entities/my_jobs_entity.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();

  Future<Either<Failure, List<MyJobsEntity>>> getMyJobs({
    required String status, // 'Applied' or 'Saved'
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, MyCompanyEntity?>> getMyCompany();

  Future<Either<Failure, bool>> updateProfile({
    String? name,
    String? email,
    String? profileImage,
  });
}
