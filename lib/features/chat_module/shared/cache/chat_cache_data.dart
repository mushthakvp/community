// Chat cache data class for memory cache
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

  bool isExpired({Duration maxAge = const Duration(minutes: 30)}) {
    return DateTime.now().difference(lastUpdated) > maxAge;
  }
}
