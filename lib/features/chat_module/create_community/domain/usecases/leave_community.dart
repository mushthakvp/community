import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/community_repository.dart';

class LeaveCommunity implements UseCase<void, LeaveCommunityParams> {
  final CommunityRepository repository;

  LeaveCommunity(this.repository);

  @override
  Future<Either<Failure, void>> call(LeaveCommunityParams params) async {
    return await repository.leaveCommunity(params.communityId);
  }
}

class LeaveCommunityParams {
  final String communityId;

  LeaveCommunityParams({required this.communityId});
}
