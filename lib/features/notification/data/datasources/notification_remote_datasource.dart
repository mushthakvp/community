import 'dart:convert';
import 'dart:developer' as dev;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/notification_entity.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    int? limit,
    int? offset,
    bool? unreadOnly,
    List<NotificationType>? types,
  });

  Future<bool> markNotificationAsRead(String notificationId);
  Future<bool> markAllNotificationsAsRead();
  Future<bool> deleteNotification(String notificationId);
  Future<int> getUnreadNotificationCount();
  Future<bool> clearAllNotifications();
  Future<NotificationModel> getNotificationById(String id);
  Future<bool> updateNotificationPreferences({
    required List<NotificationType> enabledTypes,
    required bool pushEnabled,
    required bool emailEnabled,
    required bool smsEnabled,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<NotificationModel>> getNotifications({
    int? limit,
    int? offset,
    bool? unreadOnly,
    List<NotificationType>? types,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};

      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();
      if (unreadOnly != null) queryParams['unreadOnly'] = unreadOnly.toString();
      if (types != null && types.isNotEmpty) {
        queryParams['types'] = types.map((e) => e.name).join(',');
      }

      final response = await _apiClient.get(
        ApiConstants.getNotificationUrl,
        queryParameters: queryParams,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        final notificationResponse = NotificationResponseModel.fromJson(
          responseData,
        );

        if (notificationResponse.success == true) {
          return notificationResponse.notifications ?? [];
        } else {
          throw ServerException(
            notificationResponse.message ?? 'Failed to load notifications',
          );
        }
      } else {
        final responseData = json.decode(response.body);
        throw ServerException(
          responseData['message'] ?? 'Failed to load notifications',
        );
      }
    } catch (e) {
      dev.log('Error in getNotifications: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to load notifications: ${e.toString()}');
    }
  }

  @override
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.markNotificationRead}/$notificationId',
        body: {'isRead': true},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final responseData = json.decode(response.body);
        throw ServerException(
          responseData['message'] ?? 'Failed to mark notification as read',
        );
      }
    } catch (e) {
      dev.log('Error in markNotificationAsRead: $e');
      if (e is ServerException) rethrow;
      throw ServerException(
        'Failed to mark notification as read: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> markAllNotificationsAsRead() async {
    try {
      final response = await _apiClient.put(
        ApiConstants.markAllNotificationsRead,
        body: {'markAll': true},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final responseData = json.decode(response.body);
        throw ServerException(
          responseData['message'] ?? 'Failed to mark all notifications as read',
        );
      }
    } catch (e) {
      dev.log('Error in markAllNotificationsAsRead: $e');
      if (e is ServerException) rethrow;
      throw ServerException(
        'Failed to mark all notifications as read: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final response = await _apiClient.delete(
        '${ApiConstants.deleteNotification}/$notificationId',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final responseData = json.decode(response.body);
        throw ServerException(
          responseData['message'] ?? 'Failed to delete notification',
        );
      }
    } catch (e) {
      dev.log('Error in deleteNotification: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to delete notification: ${e.toString()}');
    }
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.getUnreadNotificationCount,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return responseData['count'] ?? 0;
      } else {
        final responseData = json.decode(response.body);
        throw ServerException(
          responseData['message'] ?? 'Failed to get unread count',
        );
      }
    } catch (e) {
      dev.log('Error in getUnreadNotificationCount: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get unread count: ${e.toString()}');
    }
  }

  @override
  Future<bool> clearAllNotifications() async {
    try {
      final response = await _apiClient.delete(
        ApiConstants.clearAllNotifications,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final responseData = json.decode(response.body);
        throw ServerException(
          responseData['message'] ?? 'Failed to clear all notifications',
        );
      }
    } catch (e) {
      dev.log('Error in clearAllNotifications: $e');
      if (e is ServerException) rethrow;
      throw ServerException(
        'Failed to clear all notifications: ${e.toString()}',
      );
    }
  }

  @override
  Future<NotificationModel> getNotificationById(String id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.getNotificationById}/$id',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return NotificationModel.fromJson(responseData['notification']);
      } else {
        final responseData = json.decode(response.body);
        throw ServerException(
          responseData['message'] ?? 'Failed to get notification',
        );
      }
    } catch (e) {
      dev.log('Error in getNotificationById: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get notification: ${e.toString()}');
    }
  }

  @override
  Future<bool> updateNotificationPreferences({
    required List<NotificationType> enabledTypes,
    required bool pushEnabled,
    required bool emailEnabled,
    required bool smsEnabled,
  }) async {
    try {
      final request = NotificationPreferencesRequest(
        enabledTypes: enabledTypes.map((e) => e.name).toList(),
        pushEnabled: pushEnabled,
        emailEnabled: emailEnabled,
        smsEnabled: smsEnabled,
      );

      final response = await _apiClient.put(
        ApiConstants.updateNotificationPreferences,
        body: request.toJson(),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        final responseData = json.decode(response.body);
        throw ServerException(
          responseData['message'] ?? 'Failed to update preferences',
        );
      }
    } catch (e) {
      dev.log('Error in updateNotificationPreferences: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update preferences: ${e.toString()}');
    }
  }
}
