import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/friend_entity.dart';
import '../repositories/chat_repository.dart';

class GetFriendsUseCase {
  final ChatRepository repository;

  GetFriendsUseCase(this.repository);

  Future<Either<Failure, List<FriendEntity>>> call({String? type}) async {
    return await repository.getFriends(type: type);
  }
}
