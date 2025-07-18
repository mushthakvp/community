import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../../chat_screen/data/datasources/socket_datasource.dart';
import '../../../chat_screen/domain/entities/message_entity.dart';
import '../../domain/entities/personal_chat_entity.dart';
import '../../domain/repositories/personal_chat_repository.dart';
import '../datasources/personal_chat_remote_datasource.dart';

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
      final result = await remoteDataSource.getPersonalChatWithMessages(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
