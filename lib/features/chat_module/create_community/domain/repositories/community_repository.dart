import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/community_entity.dart';

abstract class CommunityRepository {
  Future<Either<Failure, CommunityEntity>> createCommunity({
    required String name,
    String? description,
    String? profileImage,
  });
  Future<Either<Failure, CommunityEntity>> getCommunityDetails(
    String communityId,
  );
  Future<Either<Failure, CommunityEntity>> updateCommunity({
    required String communityId,
    String? name,
    String? description,
    String? profileImage,
  });
  Future<Either<Failure, void>> deleteCommunity(String communityId);
  Future<Either<Failure, void>> joinCommunity(String communityId);
  Future<Either<Failure, void>> leaveCommunity(String communityId);
  Future<Either<Failure, String>> uploadProfileImage(String imagePath);
  Future<Either<Failure, List<MemberEntity>>> getCommunityMembers(
    String communityId,
  );
  Future<Either<Failure, void>> addMemberToCommunity({
    required String communityId,
    required String memberId,
  });
  Future<Either<Failure, void>> removeMemberFromCommunity({
    required String communityId,
    required String memberId,
  });
}
