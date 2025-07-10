import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/birthday_wish_entity.dart';
import '../repositories/chat_repository.dart';

class GetBirthdayFriendsUseCase {
  final ChatRepository repository;

  GetBirthdayFriendsUseCase(this.repository);

  Future<Either<Failure, List<BirthdayWishEntity>>> call() async {
    return await repository.getTodaysBirthdayFriends();
  }
}
