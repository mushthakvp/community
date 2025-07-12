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
    super.isCreator,
    super.isUserInGroup,
    super.isUserRequested,
    super.shareLink,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    // Handle both old and new API response formats
    final isNewFormat = json.containsKey('groupName');

    if (isNewFormat) {
      // New API format (groupDetails)
      return ChatModel(
        id: json['_id'] ?? '',
        users: [], // Members array might be empty in new format
        latestMessage: null, // Not provided in new format
        lastMessageTime: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        isGroup: true, // Assuming it's a group/community chat
        groupName: json['groupName'],
        groupImage: json['groupProfileImage'],
        wallpaper: json['userWallpaper'],
        isBot: json['isBot'] ?? false,
        role: null,
        unreadCount: 0,
        isCreator: json['isCreator'] ?? false,
        isUserInGroup: json['isUserInGroup'] ?? false,
        isUserRequested: json['isUserRequested'] ?? false,
        shareLink: json['shareLink'],
      );
    } else {
      // Old API format
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
        isCreator: json['isCreator'] ?? false,
        isUserInGroup: json['isUserInGroup'] ?? false,
        isUserRequested: json['isUserRequested'] ?? false,
        shareLink: json['shareLink'],
      );
    }
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
      'isCreator': isCreator,
      'isUserInGroup': isUserInGroup,
      'isUserRequested': isUserRequested,
      'shareLink': shareLink,
    };
  }

  ChatModel copyWith({
    String? id,
    List<UserModel>? users,
    String? latestMessage,
    DateTime? lastMessageTime,
    bool? isGroup,
    String? groupName,
    String? groupImage,
    String? wallpaper,
    bool? isBot,
    String? role,
    int? unreadCount,
    bool? isCreator,
    bool? isUserInGroup,
    bool? isUserRequested,
    String? shareLink,
  }) {
    return ChatModel(
      id: id ?? this.id,
      users: users ?? this.users,
      latestMessage: latestMessage ?? this.latestMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      isGroup: isGroup ?? this.isGroup,
      groupName: groupName ?? this.groupName,
      groupImage: groupImage ?? this.groupImage,
      wallpaper: wallpaper ?? this.wallpaper,
      isBot: isBot ?? this.isBot,
      role: role ?? this.role,
      unreadCount: unreadCount ?? this.unreadCount,
      isCreator: isCreator ?? this.isCreator,
      isUserInGroup: isUserInGroup ?? this.isUserInGroup,
      isUserRequested: isUserRequested ?? this.isUserRequested,
      shareLink: shareLink ?? this.shareLink,
    );
  }
}
