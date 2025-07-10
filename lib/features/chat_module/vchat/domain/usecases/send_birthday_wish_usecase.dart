import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/chat_repository.dart';

class SendBirthdayWishUseCase {
  final ChatRepository repository;

  SendBirthdayWishUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String friendId,
    required String message,
  }) async {
    if (friendId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Friend ID is required'));
    }

    if (message.trim().isEmpty) {
      return const Left(
        ValidationFailure(message: 'Birthday message is required'),
      );
    }

    return await repository.sendBirthdayWish(
      friendId: friendId,
      message: message.trim(),
    );
  }
}
