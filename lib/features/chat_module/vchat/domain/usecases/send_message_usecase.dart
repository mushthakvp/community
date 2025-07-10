import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessageEntity>> call({
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    Map<String, dynamic>? metadata,
  }) async {
    if (receiverId.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Receiver ID is required'));
    }

    if (content.trim().isEmpty && type == MessageType.text) {
      return const Left(
        ValidationFailure(message: 'Message content is required'),
      );
    }

    return await repository.sendMessage(
      receiverId: receiverId,
      content: content,
      type: type,
      replyToId: replyToId,
      metadata: metadata,
    );
  }
}
