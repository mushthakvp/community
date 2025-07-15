import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/community_entity.dart';

abstract class CommunityRepository {
  Future<Either<Failure, List<CommunityEntity>>> getRecommendedCommunities(
    String type,
  );
  Future<Either<Failure, List<CommunityEntity>>> getMyGroups(String type);
  Future<Either<Failure, void>> joinCommunity(String communityId);
  Future<Either<Failure, void>> leaveCommunity(String communityId);
  Future<Either<Failure, CommunityEntity>> createCommunity({
    required String name,
    required String description,
    String? image,
  });
  Future<Either<Failure, void>> acceptFriendRequest(String requestId);
  Future<Either<Failure, void>> rejectFriendRequest(String requestId);
}
