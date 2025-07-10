import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/chat_repository.dart';

class ManageFriendRequestsUseCase {
  final ChatRepository repository;

  ManageFriendRequestsUseCase(this.repository);

  Future<Either<Failure, bool>> sendRequest(String userId) async {
    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'User ID is required'));
    }
    return await repository.sendFriendRequest(userId);
  }

  Future<Either<Failure, bool>> acceptRequest(String userId) async {
    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'User ID is required'));
    }
    return await repository.acceptFriendRequest(userId);
  }

  Future<Either<Failure, bool>> rejectRequest(String userId) async {
    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'User ID is required'));
    }
    return await repository.rejectFriendRequest(userId);
  }

  Future<Either<Failure, bool>> removeFriend(String userId) async {
    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'User ID is required'));
    }
    return await repository.removeFriend(userId);
  }
}
