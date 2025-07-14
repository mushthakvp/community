import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/community_member_entity.dart';
import '../repositories/chat_profile_repository.dart';

class GetCommunityMembers
    implements UseCase<List<CommunityMemberEntity>, GetCommunityMembersParams> {
  final ChatProfileRepository repository;

  GetCommunityMembers(this.repository);

  @override
  Future<Either<Failure, List<CommunityMemberEntity>>> call(
    GetCommunityMembersParams params,
  ) async {
    return await repository.getCommunityMembers(params.communityId);
  }
}

class GetCommunityMembersParams {
  final String communityId;

  GetCommunityMembersParams({required this.communityId});
}
