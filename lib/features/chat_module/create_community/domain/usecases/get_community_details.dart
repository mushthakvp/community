import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/community_entity.dart';
import '../repositories/community_repository.dart';

class GetCommunityDetails
    implements UseCase<CommunityEntity, GetCommunityDetailsParams> {
  final CommunityRepository repository;

  GetCommunityDetails(this.repository);

  @override
  Future<Either<Failure, CommunityEntity>> call(
    GetCommunityDetailsParams params,
  ) async {
    return await repository.getCommunityDetails(params.communityId);
  }
}

class GetCommunityDetailsParams {
  final String communityId;

  GetCommunityDetailsParams({required this.communityId});
}
