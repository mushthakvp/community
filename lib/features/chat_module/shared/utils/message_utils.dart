import 'package:flutter/material.dart';

import '../../chat_screen/domain/entities/message_entity.dart';
import 'date_utils.dart';

class MessageGroup {
  final DateTime date;
  final List<MessageEntity> messages;

  MessageGroup({required this.date, required this.messages});
}

class MessageUtils {
  // Group messages by date
  static List<MessageGroup> groupMessagesByDate(List<MessageEntity> messages) {
    if (messages.isEmpty) return [];

    final Map<String, List<MessageEntity>> groupedMessages = {};

    for (final message in messages) {
      final dateKey = _getDateKey(message.createdAt);
      groupedMessages.putIfAbsent(dateKey, () => []).add(message);
    }

    // Sort groups by date and sort messages within each group
    final sortedGroups = groupedMessages.entries.map((entry) {
      final date = DateTime.parse(entry.key);
      final sortedMessages = entry.value
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return MessageGroup(date: date, messages: sortedMessages);
    }).toList()..sort((a, b) => a.date.compareTo(b.date));

    return sortedGroups;
  }

  // Helper method to get date key for grouping
  static String _getDateKey(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  // Format date header for message groups
  static String formatDateHeader(DateTime dateTime) {
    return ChatDateUtils.formatDateHeader(dateTime);
  }

  // Check if message contains media
  static bool isMediaMessage(MessageEntity message) {
    return message.mediaUrl != null && message.mediaUrl!.isNotEmpty;
  }

  // Check if message is an image
  static bool isImageMessage(MessageEntity message) {
    if (!isMediaMessage(message)) return false;

    final mediaType = message.mediaType?.toLowerCase() ?? '';
    final imageExtensions = [
      'image',
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'bmp',
    ];

    return imageExtensions.any((ext) => mediaType.contains(ext));
  }

  // Check if message is an audio/voice message
  static bool isAudioMessage(MessageEntity message) {
    if (!isMediaMessage(message)) return false;

    final mediaType = message.mediaType?.toLowerCase() ?? '';
    final audioExtensions = ['audio', 'm4a', 'mp3', 'wav', 'aac', 'ogg'];

    return audioExtensions.any((ext) => mediaType.contains(ext));
  }

  // Check if message is a video
  static bool isVideoMessage(MessageEntity message) {
    if (!isMediaMessage(message)) return false;

    final mediaType = message.mediaType?.toLowerCase() ?? '';
    final videoExtensions = ['video', 'mp4', 'avi', 'mov', 'wmv', 'mkv'];

    return videoExtensions.any((ext) => mediaType.contains(ext));
  }

  // Check if message is a document
  static bool isDocumentMessage(MessageEntity message) {
    return isMediaMessage(message) &&
        !isImageMessage(message) &&
        !isAudioMessage(message) &&
        !isVideoMessage(message);
  }

  // Get file size from URL or estimate
  static String getFileSize(MessageEntity message) {
    // This would typically come from the server
    // For now, return a placeholder
    if (isImageMessage(message)) return '< 1 MB';
    if (isAudioMessage(message)) return '< 500 KB';
    if (isVideoMessage(message)) return '< 5 MB';
    if (isDocumentMessage(message)) return 'Unknown size';
    return '';
  }

  // Extract filename from media URL
  static String getFileName(MessageEntity message) {
    if (!isMediaMessage(message)) return '';

    try {
      final uri = Uri.parse(message.mediaUrl!);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        return segments.last;
      }
    } catch (e) {
      // Fallback if URL parsing fails
    }

    // Generate a filename based on message type
    final extension = message.mediaType ?? 'file';
    final timestamp = message.createdAt.millisecondsSinceEpoch;
    return 'file_$timestamp.$extension';
  }

  // Check if message is from today
  static bool isFromToday(MessageEntity message) {
    final now = DateTime.now();
    final messageDate = message.createdAt;

    return now.year == messageDate.year &&
        now.month == messageDate.month &&
        now.day == messageDate.day;
  }

  // Check if message is from yesterday
  static bool isFromYesterday(MessageEntity message) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final messageDate = message.createdAt;

    return yesterday.year == messageDate.year &&
        yesterday.month == messageDate.month &&
        yesterday.day == messageDate.day;
  }

  // Get time ago string for message
  static String getTimeAgo(MessageEntity message) {
    final now = DateTime.now();
    final difference = now.difference(message.createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return ChatDateUtils.formatMessageTime(message.createdAt);
    }
  }

  // Search messages by content
  static List<MessageEntity> searchMessages(
    List<MessageEntity> messages,
    String query,
  ) {
    if (query.trim().isEmpty) return messages;

    final lowercaseQuery = query.toLowerCase();
    return messages.where((message) {
      final content = message.content.toLowerCase();
      final senderName = message.senderName.toLowerCase();

      return content.contains(lowercaseQuery) ||
          senderName.contains(lowercaseQuery);
    }).toList();
  }

  // Filter messages by type
  static List<MessageEntity> filterMessagesByType(
    List<MessageEntity> messages,
    MessageType type,
  ) {
    switch (type) {
      case MessageType.text:
        return messages.where((m) => !isMediaMessage(m)).toList();
      case MessageType.image:
        return messages.where(isImageMessage).toList();
      case MessageType.audio:
        return messages.where(isAudioMessage).toList();
      case MessageType.video:
        return messages.where(isVideoMessage).toList();
      case MessageType.document:
        return messages.where(isDocumentMessage).toList();
      case MessageType.all:
        return messages;
    }
  }

  // Get messages from specific sender
  static List<MessageEntity> getMessagesFromSender(
    List<MessageEntity> messages,
    String senderId,
  ) {
    return messages.where((message) => message.senderId == senderId).toList();
  }

  // Get media messages for gallery view
  static List<MessageEntity> getMediaMessages(List<MessageEntity> messages) {
    return messages
        .where((message) => isImageMessage(message) || isVideoMessage(message))
        .toList();
  }

  // Get document messages
  static List<MessageEntity> getDocumentMessages(List<MessageEntity> messages) {
    return messages.where(isDocumentMessage).toList();
  }

  // Get voice messages
  static List<MessageEntity> getVoiceMessages(List<MessageEntity> messages) {
    return messages.where(isAudioMessage).toList();
  }

  // Count messages by type
  static Map<MessageType, int> getMessageTypeCount(
    List<MessageEntity> messages,
  ) {
    return {
      MessageType.text: messages.where((m) => !isMediaMessage(m)).length,
      MessageType.image: messages.where(isImageMessage).length,
      MessageType.audio: messages.where(isAudioMessage).length,
      MessageType.video: messages.where(isVideoMessage).length,
      MessageType.document: messages.where(isDocumentMessage).length,
    };
  }

  // Get unread messages count
  static int getUnreadCount(
    List<MessageEntity> messages,
    String currentUserId,
  ) {
    return messages
        .where(
          (message) =>
              message.senderId != currentUserId && !message.isCurrentUser,
        )
        .length;
  }

  // Check if two messages are from same sender and close in time
  static bool shouldGroupWithPrevious(
    MessageEntity current,
    MessageEntity? previous,
  ) {
    if (previous == null) return false;

    // Same sender
    if (current.senderId != previous.senderId) return false;

    // Messages within 5 minutes of each other
    final timeDiff = current.createdAt.difference(previous.createdAt);
    if (timeDiff.inMinutes > 5) return false;

    return true;
  }

  // Get message reactions (if implemented)
  static List<String> getMessageReactions(MessageEntity message) {
    // This would be implemented when reactions feature is added
    return [];
  }

  // Check if message can be edited
  static bool canEditMessage(MessageEntity message) {
    // Only current user's text messages can be edited
    // And only within a certain time limit (e.g., 15 minutes)
    if (!message.isCurrentUser) return false;
    if (isMediaMessage(message)) return false;

    final timeDiff = DateTime.now().difference(message.createdAt);
    return timeDiff.inMinutes <= 15;
  }

  // Check if message can be deleted
  static bool canDeleteMessage(MessageEntity message) {
    // Current user can delete their own messages
    return message.isCurrentUser;
  }

  // Format message for sharing
  static String formatMessageForSharing(MessageEntity message) {
    final timestamp = ChatDateUtils.formatMessageTime(message.createdAt);
    final sender = message.senderName;

    if (isMediaMessage(message)) {
      final mediaType = _getMediaTypeDisplayName(message);
      final content = message.content.isNotEmpty ? ' - ${message.content}' : '';
      return '[$timestamp] $sender: $mediaType$content';
    } else {
      return '[$timestamp] $sender: ${message.content}';
    }
  }

  // Helper method to get display name for media type
  static String _getMediaTypeDisplayName(MessageEntity message) {
    if (isImageMessage(message)) return '📷 Photo';
    if (isVideoMessage(message)) return '🎥 Video';
    if (isAudioMessage(message)) return '🎵 Voice message';
    if (isDocumentMessage(message)) return '📄 Document';
    return '📎 Attachment';
  }
}

// Enum for message types
enum MessageType { all, text, image, audio, video, document }

// Extension for MessageType
extension MessageTypeExtension on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.all:
        return 'All';
      case MessageType.text:
        return 'Text';
      case MessageType.image:
        return 'Images';
      case MessageType.audio:
        return 'Audio';
      case MessageType.video:
        return 'Videos';
      case MessageType.document:
        return 'Documents';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageType.all:
        return Icons.all_inclusive;
      case MessageType.text:
        return Icons.text_fields;
      case MessageType.image:
        return Icons.image;
      case MessageType.audio:
        return Icons.audiotrack;
      case MessageType.video:
        return Icons.videocam;
      case MessageType.document:
        return Icons.description;
    }
  }
}
