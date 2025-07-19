import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/profile_data.dart';
import '../repositories/profile_repository.dart';

class GetProfileData implements UseCase<ProfileData, NoParams> {
  final ProfileRepository repository;

  GetProfileData(this.repository);

  @override
  Future<Either<Failure, ProfileData>> call(NoParams params) async {
    return await repository.getProfileData();
  }
}
