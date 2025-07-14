import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/friend_entity.dart';
import '../repositories/chat_profile_repository.dart';

class GetFriends implements UseCase<List<FriendEntity>, NoParams> {
  final ChatProfileRepository repository;

  GetFriends(this.repository);

  @override
  Future<Either<Failure, List<FriendEntity>>> call(NoParams params) async {
    return await repository.getFriends();
  }
}
