import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? imageUrl;
  final String? deepLink;
  final NotificationType type;
  final Map<String, dynamic>? metadata;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.imageUrl,
    this.deepLink,
    this.type = NotificationType.general,
    this.metadata,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
    String? imageUrl,
    String? deepLink,
    NotificationType? type,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      deepLink: deepLink ?? this.deepLink,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper methods
  String get displayTitle => title.isNotEmpty ? title : 'Notification';

  String get displayMessage => message.isNotEmpty ? message : 'No message';

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${difference.inDays > 60 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String get dateKey {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (createdAt.isAfter(today)) {
      return 'Today';
    } else if (createdAt.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";
    }
  }

  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  bool get isYesterday {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return createdAt.year == yesterday.year &&
        createdAt.month == yesterday.month &&
        createdAt.day == yesterday.day;
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  bool get hasDeepLink => deepLink != null && deepLink!.isNotEmpty;

  bool get isValid => id.isNotEmpty && title.isNotEmpty;

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

  @override
  String toString() {
    return 'NotificationEntity(id: $id, title: $title, message: $message, createdAt: $createdAt, isRead: $isRead, type: $type)';
  }
}

enum NotificationType {
  general,
  promotion,
  account,
  payment,
  system,
  chat,
  offer,
  reminder,
  update,
  alert,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.general:
        return 'General';
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.account:
        return 'Account';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.system:
        return 'System';
      case NotificationType.chat:
        return 'Chat';
      case NotificationType.offer:
        return 'Offer';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.update:
        return 'Update';
      case NotificationType.alert:
        return 'Alert';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.general:
        return Icons.notifications_outlined;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
      case NotificationType.account:
        return Icons.account_circle_outlined;
      case NotificationType.payment:
        return Icons.payment_outlined;
      case NotificationType.system:
        return Icons.settings_outlined;
      case NotificationType.chat:
        return Icons.chat_outlined;
      case NotificationType.offer:
        return Icons.discount_outlined;
      case NotificationType.reminder:
        return Icons.schedule_outlined;
      case NotificationType.update:
        return Icons.system_update_outlined;
      case NotificationType.alert:
        return Icons.warning_amber_outlined;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.general:
        return Colors.blue;
      case NotificationType.promotion:
        return Colors.green;
      case NotificationType.account:
        return Colors.purple;
      case NotificationType.payment:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.chat:
        return Colors.teal;
      case NotificationType.offer:
        return Colors.pink;
      case NotificationType.reminder:
        return Colors.amber;
      case NotificationType.update:
        return Colors.indigo;
      case NotificationType.alert:
        return Colors.red;
    }
  }
}
