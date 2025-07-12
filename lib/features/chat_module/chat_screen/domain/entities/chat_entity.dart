import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class ChatEntity extends Equatable {
  final String id;
  final List<UserEntity> users;
  final String? latestMessage;
  final DateTime? lastMessageTime;
  final bool isGroup;
  final String? groupName;
  final String? groupImage;
  final String? wallpaper;
  final bool isBot;
  final String? role;
  final int unreadCount;
  final bool isCreator;
  final bool isUserInGroup;
  final bool isUserRequested;
  final String? shareLink;

  const ChatEntity({
    required this.id,
    required this.users,
    this.latestMessage,
    this.lastMessageTime,
    this.isGroup = false,
    this.groupName,
    this.groupImage,
    this.wallpaper,
    this.isBot = false,
    this.role,
    this.unreadCount = 0,
    this.isCreator = false,
    this.isUserInGroup = false,
    this.isUserRequested = false,
    this.shareLink,
  });

  @override
  List<Object?> get props => [
    id,
    users,
    latestMessage,
    lastMessageTime,
    isGroup,
    groupName,
    groupImage,
    wallpaper,
    isBot,
    role,
    unreadCount,
    isCreator,
    isUserInGroup,
    isUserRequested,
    shareLink,
  ];
}
