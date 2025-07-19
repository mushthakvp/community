import '../../chat_screen/domain/entities/chat_entity.dart';
import '../../chat_screen/domain/entities/message_entity.dart';

class ChatCacheData {
  final ChatEntity chat;
  final List<MessageEntity> messages;
  DateTime lastUpdated;

  ChatCacheData({
    required this.chat,
    required this.messages,
    required this.lastUpdated,
  });

  bool isExpired({Duration timeout = const Duration(minutes: 30)}) {
    return DateTime.now().difference(lastUpdated) > timeout;
  }

  ChatCacheData copyWith({
    ChatEntity? chat,
    List<MessageEntity>? messages,
    DateTime? lastUpdated,
  }) {
    return ChatCacheData(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
