import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/member_request_entity.dart';
import '../repositories/chat_profile_repository.dart';

class GetMemberRequests
    implements UseCase<MemberRequestsEntity, GetMemberRequestsParams> {
  final ChatProfileRepository repository;

  GetMemberRequests(this.repository);

  @override
  Future<Either<Failure, MemberRequestsEntity>> call(
    GetMemberRequestsParams params,
  ) async {
    return await repository.getMemberRequests(params.communityId);
  }
}

class GetMemberRequestsParams {
  final String communityId;

  GetMemberRequestsParams({required this.communityId});
}
