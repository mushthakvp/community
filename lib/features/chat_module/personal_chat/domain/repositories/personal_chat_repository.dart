import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../chat_screen/domain/entities/message_entity.dart';
import '../entities/personal_chat_entity.dart';

abstract class PersonalChatRepository {
  Future<Either<Failure, List<PersonalChatEntity>>> getPersonalChats();
  Future<Either<Failure, PersonalChatEntity>> getPersonalChat(String userId);
  Future<Either<Failure, List<MessageEntity>>> getPersonalChatMessages(
    String userId,
  );
  Future<Either<Failure, MessageEntity>> sendPersonalMessage({
    required String receiverId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  });
  Stream<MessageEntity> listenToPersonalMessages();
  Future<Either<Failure, Map<String, dynamic>>> getPersonalChatWithMessages(
    String userId,
  );
}
