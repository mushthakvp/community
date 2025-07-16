import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessage implements UseCase<MessageEntity, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      chatId: params.chatId,
      content: params.content,
      mediaUrl: params.mediaUrl,
      mediaType: params.mediaType,
    );
  }
}

class SendMessageParams {
  final String chatId;
  final String content;
  final String? mediaUrl;
  final String? mediaType;

  SendMessageParams({
    required this.chatId,
    required this.content,
    this.mediaUrl,
    this.mediaType,
  });
}
