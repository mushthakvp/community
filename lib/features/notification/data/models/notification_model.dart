import 'package:equatable/equatable.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final List<NotificationModel>? notifications;
  final int? total;
  final int? unreadCount;

  const NotificationResponseModel({
    this.success,
    this.message,
    this.notifications,
    this.total,
    this.unreadCount,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationResponseModel(
        success: json["success"] as bool?,
        message: json["message"] as String?,
        notifications: json["notifications"] != null
            ? List<NotificationModel>.from(
                (json["notifications"] as List).map(
                  (x) => NotificationModel.fromJson(x),
                ),
              )
            : null,
        total: json["total"] as int?,
        unreadCount: json["unreadCount"] as int?,
      );
    } catch (e) {
      return const NotificationResponseModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "notifications": notifications?.map((x) => x.toJson()).toList(),
    "total": total,
    "unreadCount": unreadCount,
  };

  @override
  List<Object?> get props => [
    success,
    message,
    notifications,
    total,
    unreadCount,
  ];
}

// Individual notification model
class NotificationModel extends Equatable {
  final String? id;
  final String? title;
  final String? message;
  final DateTime? createdAt;
  final bool? isRead;
  final String? imageUrl;
  final String? deepLink;
  final String? type;
  final Map<String, dynamic>? metadata;

  const NotificationModel({
    this.id,
    this.title,
    this.message,
    this.createdAt,
    this.isRead,
    this.imageUrl,
    this.deepLink,
    this.type,
    this.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationModel(
        id: json["_id"] as String? ?? json["id"] as String?,
        title: json["title"] as String?,
        message: json["message"] as String?,
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        isRead: json["isRead"] as bool? ?? json["read"] as bool? ?? false,
        imageUrl: json["imageUrl"] as String? ?? json["image"] as String?,
        deepLink: json["deepLink"] as String? ?? json["link"] as String?,
        type: json["type"] as String?,
        metadata: json["metadata"] as Map<String, dynamic>?,
      );
    } catch (e) {
      return const NotificationModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "message": message,
    "createdAt": createdAt?.toIso8601String(),
    "isRead": isRead,
    "imageUrl": imageUrl,
    "deepLink": deepLink,
    "type": type,
    "metadata": metadata,
  };

  // Convert to domain entity
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id ?? '',
      title: title ?? '',
      message: message ?? '',
      createdAt: createdAt ?? DateTime.now(),
      isRead: isRead ?? false,
      imageUrl: imageUrl,
      deepLink: deepLink,
      type: _parseNotificationType(type),
      metadata: metadata,
    );
  }

  // Convert from domain entity
  static NotificationModel fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      createdAt: entity.createdAt,
      isRead: entity.isRead,
      imageUrl: entity.imageUrl,
      deepLink: entity.deepLink,
      type: entity.type.name,
      metadata: entity.metadata,
    );
  }

  static NotificationType _parseNotificationType(String? type) {
    if (type == null) return NotificationType.general;

    switch (type.toLowerCase()) {
      case 'general':
        return NotificationType.general;
      case 'promotion':
      case 'promo':
        return NotificationType.promotion;
      case 'account':
        return NotificationType.account;
      case 'payment':
        return NotificationType.payment;
      case 'system':
        return NotificationType.system;
      case 'chat':
        return NotificationType.chat;
      case 'offer':
        return NotificationType.offer;
      case 'reminder':
        return NotificationType.reminder;
      case 'update':
        return NotificationType.update;
      case 'alert':
        return NotificationType.alert;
      default:
        return NotificationType.general;
    }
  }

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    createdAt,
    isRead,
    imageUrl,
    deepLink,
    type,
    metadata,
  ];
}

// Request models for API calls
class MarkNotificationReadRequest extends Equatable {
  final String notificationId;

  const MarkNotificationReadRequest({required this.notificationId});

  Map<String, dynamic> toJson() => {"notificationId": notificationId};

  @override
  List<Object?> get props => [notificationId];
}

class NotificationPreferencesRequest extends Equatable {
  final List<String> enabledTypes;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;

  const NotificationPreferencesRequest({
    required this.enabledTypes,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.smsEnabled,
  });

  Map<String, dynamic> toJson() => {
    "enabledTypes": enabledTypes,
    "pushEnabled": pushEnabled,
    "emailEnabled": emailEnabled,
    "smsEnabled": smsEnabled,
  };

  @override
  List<Object?> get props => [
    enabledTypes,
    pushEnabled,
    emailEnabled,
    smsEnabled,
  ];
}
