import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../chat_screen/data/datasources/socket_datasource.dart';
import '../../../chat_screen/domain/entities/message_entity.dart';
import '../../domain/entities/personal_chat_entity.dart';
import '../../domain/repositories/personal_chat_repository.dart';
import '../datasources/personal_chat_remote_datasource.dart';
import '../models/personal_chat_model.dart';

class PersonalChatRepositoryImpl implements PersonalChatRepository {
  final PersonalChatRemoteDataSource remoteDataSource;
  final SocketDataSource socketDataSource;

  PersonalChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketDataSource,
  });

  @override
  Future<Either<Failure, List<PersonalChatEntity>>> getPersonalChats() async {
    try {
      final chats = await remoteDataSource.getPersonalChats();
      return Right(chats);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PersonalChatEntity>> getPersonalChat(
    String userId,
  ) async {
    try {
      final chat = await remoteDataSource.getPersonalChat(userId);
      return Right(chat);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getPersonalChatMessages(
    String userId,
  ) async {
    try {
      final messages = await remoteDataSource.getPersonalChatMessages(userId);

      // Update messages with current user flag
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
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendPersonalMessage({
    required String receiverId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  }) async {
    try {
      // Ensure socket connection and join personal chat room
      if (socketDataSource is SocketDataSourceImpl) {
        final socketImpl = socketDataSource as SocketDataSourceImpl;
        if (!socketImpl.isConnected) {
          await socketDataSource.connect();
        }
        await socketDataSource.joinPersonalChat(receiverId);
      }

      final message = await socketDataSource.sendPersonalMessage(
        receiverId: receiverId,
        content: content,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<MessageEntity> listenToPersonalMessages() {
    return socketDataSource.listenToPersonalMessages();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getPersonalChatWithMessages(
    String userId,
  ) async {
    try {
      log("Getting");
      final result = await remoteDataSource.getPersonalChatWithMessages(userId);
      final personalChatModel = result['chat'] as PersonalChatModel;
      final chatEntity = personalChatModel.toChatEntity();
      final currentUserId = await StorageService.getUserId();
      final messages = result['messages'] as List<MessageEntity>;
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

      return Right({'chat': chatEntity, 'messages': updatedMessages});
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
