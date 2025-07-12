import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class FetchMessages
    implements UseCase<List<MessageEntity>, FetchMessagesParams> {
  final ChatRepository repository;

  FetchMessages(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(
    FetchMessagesParams params,
  ) async {
    final result = await repository.getMessages(params.chatId);
    return result.fold((failure) => Left(failure), (messages) async {
      final currentUserId = await StorageService.getUserId();
      final updatedMessages = messages.map((message) {
        return MessageEntity(
          id: message.id,
          chatId: message.chatId,
          senderId: message.senderId,
          senderName: message.senderName,
          senderImage: message.senderImage,
          content: message.content,
          mediaUrl: message.mediaUrl,
          mediaType: message.mediaType,
          createdAt: message.createdAt,
          isDeleted: message.isDeleted,
          isCurrentUser: message.senderId == currentUserId,
        );
      }).toList();
      return Right(updatedMessages);
    });
  }
}

class FetchMessagesParams {
  final String chatId;

  FetchMessagesParams({required this.chatId});
}
