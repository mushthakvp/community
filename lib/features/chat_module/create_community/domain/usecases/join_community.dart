import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/community_repository.dart';

class JoinCommunity implements UseCase<void, JoinCommunityParams> {
  final CommunityRepository repository;

  JoinCommunity(this.repository);

  @override
  Future<Either<Failure, void>> call(JoinCommunityParams params) async {
    return await repository.joinCommunity(params.communityId);
  }
}

class JoinCommunityParams {
  final String communityId;

  JoinCommunityParams({required this.communityId});
}
