import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/community_repository.dart';

class AcceptFriendRequest implements UseCase<void, AcceptFriendRequestParams> {
  final CommunityRepository repository;

  AcceptFriendRequest(this.repository);

  @override
  Future<Either<Failure, void>> call(AcceptFriendRequestParams params) async {
    return repository.acceptFriendRequest(params.requestId);
  }
}

class AcceptFriendRequestParams {
  final String requestId;

  AcceptFriendRequestParams({required this.requestId});
}
