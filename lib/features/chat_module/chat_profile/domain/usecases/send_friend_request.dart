import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/chat_profile_repository.dart';

class SendFriendRequest implements UseCase<void, SendFriendRequestParams> {
  final ChatProfileRepository repository;

  SendFriendRequest(this.repository);

  @override
  Future<Either<Failure, void>> call(SendFriendRequestParams params) async {
    return await repository.sendFriendRequest(params.userId);
  }
}

class SendFriendRequestParams {
  final String userId;

  SendFriendRequestParams({required this.userId});
}
