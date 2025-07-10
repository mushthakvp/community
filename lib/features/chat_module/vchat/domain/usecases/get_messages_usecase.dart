import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<ChatMessageEntity>>> call({
    required String chatId,
    int? limit,
    String? lastMessageId,
  }) async {
    if (chatId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Chat ID is required'));
    }

    return await repository.getMessages(
      chatId: chatId,
      limit: limit,
      lastMessageId: lastMessageId,
    );
  }
}
