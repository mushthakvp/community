import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../data/datasources/socket_datasource.dart';
import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatEntity>> getChat(String chatId);
  Future<Either<Failure, List<MessageEntity>>> getMessages(String chatId);
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String chatId,
    required String content,
    String? mediaUrl,
    String? mediaType,
    ChatType chatType = ChatType.community,
  });
  Future<Either<Failure, String>> uploadMedia(String filePath);
  Stream<MessageEntity> listenToNewMessages(String chatId);
  Future<Either<Failure, void>> markMessageAsRead(String messageId);
  Future<Either<Failure, Map<String, dynamic>>> getChatWithMessages(
    String chatId,
  );
  Future<Either<Failure, void>> joinGroup(String chatId);
}
