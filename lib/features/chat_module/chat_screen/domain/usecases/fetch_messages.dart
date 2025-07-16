import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
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

// Add new use case for fetching chat with messages
class FetchChatWithMessages
    implements UseCase<Map<String, dynamic>, FetchChatWithMessagesParams> {
  final ChatRepository repository;

  FetchChatWithMessages(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    FetchChatWithMessagesParams params,
  ) async {
    final result = await repository.getChatWithMessages(params.chatId);
    return result.fold((failure) => Left(failure), (data) async {
      final currentUserId = await StorageService.getUserId();
      final chat = data['chat'] as ChatEntity;
      final messages = data['messages'] as List<MessageEntity>;

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

      return Right({'chat': chat, 'messages': updatedMessages});
    });
  }
}

class FetchMessagesParams {
  final String chatId;

  FetchMessagesParams({required this.chatId});
}

class FetchChatWithMessagesParams {
  final String chatId;

  FetchChatWithMessagesParams({required this.chatId});
}
