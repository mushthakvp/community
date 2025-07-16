import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/community_entity.dart';
import '../repositories/community_repository.dart';

class GetRecommendedCommunities
    implements UseCase<List<CommunityEntity>, GetRecommendedCommunitiesParams> {
  final CommunityRepository repository;

  GetRecommendedCommunities(this.repository);

  @override
  Future<Either<Failure, List<CommunityEntity>>> call(
    GetRecommendedCommunitiesParams params,
  ) async {
    return await repository.getRecommendedCommunities(params.type);
  }
}

class GetRecommendedCommunitiesParams {
  final String type;

  GetRecommendedCommunitiesParams({required this.type});
}
