import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/community_info_entity.dart';
import '../repositories/chat_profile_repository.dart';

class GetCommunityInfo
    implements UseCase<CommunityInfoEntity, GetCommunityInfoParams> {
  final ChatProfileRepository repository;

  GetCommunityInfo(this.repository);

  @override
  Future<Either<Failure, CommunityInfoEntity>> call(
    GetCommunityInfoParams params,
  ) async {
    return await repository.getCommunityInfo(params.communityId);
  }
}

class GetCommunityInfoParams {
  final String communityId;

  GetCommunityInfoParams({required this.communityId});
}
