import 'package:equatable/equatable.dart';

import '../../../chat_screen/domain/entities/user_entity.dart';

class PersonalChatEntity extends Equatable {
  final String id;
  final UserEntity friend;
  final String? latestMessage;
  final DateTime? lastMessageTime;
  final bool isOnline;
  final int unreadCount;

  const PersonalChatEntity({
    required this.id,
    required this.friend,
    this.latestMessage,
    this.lastMessageTime,
    this.isOnline = false,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    friend,
    latestMessage,
    lastMessageTime,
    isOnline,
    unreadCount,
  ];
}
