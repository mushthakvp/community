import '../../../chat_screen/data/models/user_model.dart';
import '../../../chat_screen/domain/entities/chat_entity.dart';
import '../../domain/entities/personal_chat_entity.dart';

class PersonalChatModel extends PersonalChatEntity {
  const PersonalChatModel({
    required super.id,
    required super.friend,
    super.latestMessage,
    super.lastMessageTime,
    super.isOnline,
    super.unreadCount,
  });

  factory PersonalChatModel.fromJson(Map<String, dynamic> json) {
    UserModel friend;
    if (json.containsKey('users') && json['users'] is List) {
      final users = json['users'] as List<dynamic>;
      if (users.isNotEmpty) {
        friend = UserModel.fromJson(users.first);
      } else {
        friend = const UserModel(id: '', name: 'Unknown User');
      }
    } else {
      friend = UserModel.fromJson(json);
    }
    return PersonalChatModel(
      id: json['_id'] ?? friend.id,
      friend: friend,
      latestMessage: json['latestMessage'],
      lastMessageTime: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isOnline: json['isOnline'] ?? friend.isOnline,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'friend': (friend as UserModel).toJson(),
      'latestMessage': latestMessage,
      'updatedAt': lastMessageTime?.toIso8601String(),
      'isOnline': isOnline,
      'unreadCount': unreadCount,
    };
  }

  PersonalChatModel copyWith({
    String? id,
    UserModel? friend,
    String? latestMessage,
    DateTime? lastMessageTime,
    bool? isOnline,
    int? unreadCount,
  }) {
    return PersonalChatModel(
      id: id ?? this.id,
      friend: friend ?? this.friend,
      latestMessage: latestMessage ?? this.latestMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isOnline: isOnline ?? this.isOnline,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  ChatEntity toChatEntity() {
    return ChatEntity(
      id: id,
      users: [friend as UserModel],
      latestMessage: latestMessage,
      lastMessageTime: lastMessageTime,
      isGroup: false,
      groupName: null,
      groupImage: null,
      wallpaper: null,
      isBot: false,
      role: null,
      unreadCount: unreadCount,
      isCreator: false,
      isUserInGroup: true,
      isUserRequested: false,
      shareLink: null,
    );
  }

  static PersonalChatModel fromChatEntity(ChatEntity chatEntity) {
    final friend = chatEntity.users.isNotEmpty
        ? chatEntity.users.first as UserModel
        : const UserModel(id: '', name: 'Unknown User');

    return PersonalChatModel(
      id: chatEntity.id,
      friend: friend,
      latestMessage: chatEntity.latestMessage,
      lastMessageTime: chatEntity.lastMessageTime,
      isOnline: friend.isOnline,
      unreadCount: chatEntity.unreadCount,
    );
  }
}

class PersonalChatResponseModel {
  final bool success;
  final String message;
  final PersonalChatModel? chat;
  final List<dynamic>? messages;

  PersonalChatResponseModel({
    required this.success,
    required this.message,
    this.chat,
    this.messages,
  });

  factory PersonalChatResponseModel.fromJson(Map<String, dynamic> json) {
    return PersonalChatResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      chat: json['chat'] != null
          ? PersonalChatModel.fromJson(json['chat'])
          : null,
      messages: json['messages'],
    );
  }
}
