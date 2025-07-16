import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  /// Get all notifications for the current user
  /// Returns a list of notifications or a failure
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int? limit,
    int? offset,
    bool? unreadOnly,
    List<NotificationType>? types,
  });

  /// Mark a notification as read
  /// Returns true if successful, false otherwise
  Future<Either<Failure, bool>> markNotificationAsRead(String notificationId);

  /// Mark all notifications as read
  /// Returns true if successful, false otherwise
  Future<Either<Failure, bool>> markAllNotificationsAsRead();

  /// Delete a notification
  /// Returns true if successful, false otherwise
  Future<Either<Failure, bool>> deleteNotification(String notificationId);

  /// Get unread notification count
  /// Returns the count or a failure
  Future<Either<Failure, int>> getUnreadNotificationCount();

  /// Clear all notifications
  /// Returns true if successful, false otherwise
  Future<Either<Failure, bool>> clearAllNotifications();

  /// Get notification by ID
  /// Returns a notification or a failure
  Future<Either<Failure, NotificationEntity>> getNotificationById(String id);

  /// Update notification preferences
  /// Returns true if successful, false otherwise
  Future<Either<Failure, bool>> updateNotificationPreferences({
    required List<NotificationType> enabledTypes,
    required bool pushEnabled,
    required bool emailEnabled,
    required bool smsEnabled,
  });
}
