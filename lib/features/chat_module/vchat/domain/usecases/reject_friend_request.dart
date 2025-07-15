import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/community_repository.dart';

class RejectFriendRequest implements UseCase<void, RejectFriendRequestParams> {
  final CommunityRepository repository;

  RejectFriendRequest(this.repository);

  @override
  Future<Either<Failure, void>> call(RejectFriendRequestParams params) async {
    return repository.rejectFriendRequest(params.requestId);
  }
}

class RejectFriendRequestParams {
  final String requestId;

  RejectFriendRequestParams({required this.requestId});
}
