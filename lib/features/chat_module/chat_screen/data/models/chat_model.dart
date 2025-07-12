import '../../domain/entities/chat_entity.dart';
import 'user_model.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.users,
    super.latestMessage,
    super.lastMessageTime,
    super.isGroup,
    super.groupName,
    super.groupImage,
    super.wallpaper,
    super.isBot,
    super.role,
    super.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      users:
          (json['users'] as List<dynamic>?)
              ?.map((user) => UserModel.fromJson(user))
              .toList() ??
          [],
      latestMessage: json['latestMessage'],
      lastMessageTime: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isGroup: json['isGroup'] ?? false,
      groupName: json['groupName'],
      groupImage: json['groupProfileImage'],
      wallpaper: json['wallpapers'],
      isBot: json['isBot'] ?? false,
      role: json['role'],
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'users': users.map((user) => (user as UserModel).toJson()).toList(),
      'latestMessage': latestMessage,
      'updatedAt': lastMessageTime?.toIso8601String(),
      'isGroup': isGroup,
      'groupName': groupName,
      'groupProfileImage': groupImage,
      'wallpapers': wallpaper,
      'isBot': isBot,
      'role': role,
      'unreadCount': unreadCount,
    };
  }
}
