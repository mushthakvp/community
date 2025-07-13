import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.senderName,
    super.senderImage,
    required super.content,
    super.mediaUrl,
    super.mediaType,
    required super.createdAt,
    super.isDeleted,
    super.isCurrentUser,
  });

  // In lib/features/chat_module/chat_screen/data/models/message_model.dart
  // Replace the fromJson method

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    String chatId = '';
    if (json.containsKey('chat') && json['chat'] != null) {
      chatId = json['chat'].toString();
    } else if (json.containsKey('community') && json['community'] != null) {
      chatId = json['community'].toString();
    } else if (json.containsKey('communityId') && json['communityId'] != null) {
      chatId = json['communityId'].toString();
    } else if (json.containsKey('chatId') && json['chatId'] != null) {
      chatId = json['chatId'].toString();
    }

    return MessageModel(
      id: json['_id'] ?? '',
      chatId: chatId,
      senderId: json['sender']?['_id'] ?? '',
      senderName: json['sender']?['name'] ?? '',
      senderImage: json['sender']?['profileImage'],
      content: json['content'] ?? '',
      mediaUrl: json['media'],
      mediaType: json['ext'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isDeleted: json['deleted'] ?? false,
      isCurrentUser: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chat': chatId,
      'sender': {
        '_id': senderId,
        'name': senderName,
        'profileImage': senderImage,
      },
      'content': content,
      'media': mediaUrl,
      'ext': mediaType,
      'createdAt': createdAt.toIso8601String(),
      'deleted': isDeleted,
    };
  }

  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? senderImage,
    String? content,
    String? mediaUrl,
    String? mediaType,
    DateTime? createdAt,
    bool? isDeleted,
    bool? isCurrentUser,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImage: senderImage ?? this.senderImage,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
