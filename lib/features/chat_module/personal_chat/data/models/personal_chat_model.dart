import '../../../chat_screen/data/models/user_model.dart';
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
    // Handle different response formats
    UserModel friend;

    if (json.containsKey('users') && json['users'] is List) {
      // If it's a chat object with users array
      final users = json['users'] as List<dynamic>;
      if (users.isNotEmpty) {
        friend = UserModel.fromJson(users.first);
      } else {
        // Fallback friend data
        friend = const UserModel(id: '', name: 'Unknown User');
      }
    } else {
      // If it's directly a user/friend object
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
}
