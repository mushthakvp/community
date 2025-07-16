import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/community_info_entity.dart';
import '../entities/community_member_entity.dart';
import '../entities/friend_entity.dart';
import '../entities/member_request_entity.dart';

abstract class ChatProfileRepository {
  Future<Either<Failure, List<CommunityMemberEntity>>> getCommunityMembers(
    String communityId,
  );
  Future<Either<Failure, void>> removeMember(String communityId, String userId);
  Future<Either<Failure, void>> addMembers(
    String communityId,
    List<String> memberIds,
  );
  Future<Either<Failure, MemberRequestsEntity>> getMemberRequests(
    String communityId,
  );
  Future<Either<Failure, void>> approveRequest(
    String communityId,
    String requestId,
  );
  Future<Either<Failure, void>> rejectRequest(
    String communityId,
    String requestId,
  );
  Future<Either<Failure, List<FriendEntity>>> getFriends();
  Future<Either<Failure, void>> sendFriendRequest(String userId);
  Future<Either<Failure, CommunityInfoEntity>> getCommunityInfo(
    String communityId,
  );
  Future<Either<Failure, void>> leaveCommunity(String communityId);
}
