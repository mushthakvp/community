import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int? limit,
    int? offset,
    bool? unreadOnly,
    List<NotificationType>? types,
  }) async {
    try {
      final notifications = await _remoteDataSource.getNotifications(
        limit: limit,
        offset: offset,
        unreadOnly: unreadOnly,
        types: types,
      );

      final entities = notifications.map((model) => model.toEntity()).toList();

      // Sort notifications by creation date (newest first)
      entities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(entities);
    } on ServerException catch (e) {
      dev.log('Server exception in getNotifications: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getNotifications: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getNotifications',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      if (notificationId.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Notification ID cannot be empty'),
        );
      }

      final success = await _remoteDataSource.markNotificationAsRead(
        notificationId,
      );
      return Right(success);
    } on ServerException catch (e) {
      dev.log('Server exception in markNotificationAsRead: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in markNotificationAsRead: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in markNotificationAsRead',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAllNotificationsAsRead() async {
    try {
      final success = await _remoteDataSource.markAllNotificationsAsRead();
      return Right(success);
    } on ServerException catch (e) {
      dev.log('Server exception in markAllNotificationsAsRead: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in markAllNotificationsAsRead: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in markAllNotificationsAsRead',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNotification(
    String notificationId,
  ) async {
    try {
      if (notificationId.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Notification ID cannot be empty'),
        );
      }

      final success = await _remoteDataSource.deleteNotification(
        notificationId,
      );
      return Right(success);
    } on ServerException catch (e) {
      dev.log('Server exception in deleteNotification: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in deleteNotification: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in deleteNotification',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadNotificationCount() async {
    try {
      final count = await _remoteDataSource.getUnreadNotificationCount();
      return Right(count);
    } on ServerException catch (e) {
      dev.log('Server exception in getUnreadNotificationCount: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getUnreadNotificationCount: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getUnreadNotificationCount',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearAllNotifications() async {
    try {
      final success = await _remoteDataSource.clearAllNotifications();
      return Right(success);
    } on ServerException catch (e) {
      dev.log('Server exception in clearAllNotifications: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in clearAllNotifications: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in clearAllNotifications',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> getNotificationById(
    String id,
  ) async {
    try {
      if (id.trim().isEmpty) {
        return const Left(
          ValidationFailure(message: 'Notification ID cannot be empty'),
        );
      }

      final notificationModel = await _remoteDataSource.getNotificationById(id);
      return Right(notificationModel.toEntity());
    } on ServerException catch (e) {
      dev.log('Server exception in getNotificationById: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getNotificationById: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getNotificationById',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNotificationPreferences({
    required List<NotificationType> enabledTypes,
    required bool pushEnabled,
    required bool emailEnabled,
    required bool smsEnabled,
  }) async {
    try {
      final success = await _remoteDataSource.updateNotificationPreferences(
        enabledTypes: enabledTypes,
        pushEnabled: pushEnabled,
        emailEnabled: emailEnabled,
        smsEnabled: smsEnabled,
      );
      return Right(success);
    } on ServerException catch (e) {
      dev.log(
        'Server exception in updateNotificationPreferences: ${e.message}',
      );
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log(
        'Network exception in updateNotificationPreferences: ${e.message}',
      );
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in updateNotificationPreferences',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
