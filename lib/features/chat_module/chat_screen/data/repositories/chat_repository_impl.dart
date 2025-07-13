import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../datasources/socket_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final SocketDataSource socketDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketDataSource,
  });

  @override
  Future<Either<Failure, ChatEntity>> getChat(String chatId) async {
    try {
      final chat = await remoteDataSource.getChat(chatId);
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
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String chatId,
  ) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getChatWithMessages(
    String chatId,
  ) async {
    try {
      final result = await remoteDataSource.getChatWithMessages(chatId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String chatId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  }) async {
    try {
      // Ensure socket is connected before sending
      if (socketDataSource is SocketDataSourceImpl) {
        final socketImpl = socketDataSource as SocketDataSourceImpl;
        if (!socketImpl.isConnected) {
          await socketDataSource.connect();
        }
      }

      final message = await socketDataSource.sendMessage(
        chatId: chatId,
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
  Future<Either<Failure, String>> uploadMedia(String filePath) async {
    try {
      final url = await remoteDataSource.uploadMedia(filePath);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<MessageEntity> listenToNewMessages(String chatId) {
    return socketDataSource.listenToNewMessages(chatId);
  }

  @override
  Future<Either<Failure, void>> markMessageAsRead(String messageId) async {
    try {
      await remoteDataSource.markMessageAsRead(messageId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinGroup(String chatId) async {
    try {
      await remoteDataSource.joinGroup(chatId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
