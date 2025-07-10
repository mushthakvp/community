import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message_entity.dart';

class ChatMessageResponseModel extends Equatable {
  final bool? success;
  final List<ChatMessageModel>? data;
  final String? message;

  const ChatMessageResponseModel({this.success, this.data, this.message});

  factory ChatMessageResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return ChatMessageResponseModel(
        success: json["success"] as bool?,
        data: json["data"] != null
            ? List<ChatMessageModel>.from(
                (json["data"] as List).map((x) => ChatMessageModel.fromJson(x)),
              )
            : null,
        message: json["message"] as String?,
      );
    } catch (e) {
      return const ChatMessageResponseModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.map((x) => x.toJson()).toList(),
    "message": message,
  };

  @override
  List<Object?> get props => [success, data, message];
}

class ChatMessageModel extends Equatable {
  final String? id;
  final String? senderId;
  final String? senderName;
  final String? senderAvatar;
  final String? receiverId;
  final String? content;
  final String? type;
  final String? status;
  final DateTime? timestamp;
  final String? replyToId;
  final Map<String, dynamic>? metadata;

  const ChatMessageModel({
    this.id,
    this.senderId,
    this.senderName,
    this.senderAvatar,
    this.receiverId,
    this.content,
    this.type,
    this.status,
    this.timestamp,
    this.replyToId,
    this.metadata,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    try {
      return ChatMessageModel(
        id: json["_id"] as String? ?? json["id"] as String?,
        senderId: json["senderId"] as String?,
        senderName: json["senderName"] as String?,
        senderAvatar: json["senderAvatar"] as String?,
        receiverId: json["receiverId"] as String?,
        content: json["content"] as String?,
        type: json["type"] as String?,
        status: json["status"] as String?,
        timestamp: json["timestamp"] != null
            ? DateTime.tryParse(json["timestamp"])
            : null,
        replyToId: json["replyToId"] as String?,
        metadata: json["metadata"] as Map<String, dynamic>?,
      );
    } catch (e) {
      return const ChatMessageModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "senderId": senderId,
    "senderName": senderName,
    "senderAvatar": senderAvatar,
    "receiverId": receiverId,
    "content": content,
    "type": type,
    "status": status,
    "timestamp": timestamp?.toIso8601String(),
    "replyToId": replyToId,
    "metadata": metadata,
  };

  // Convert to Entity
  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id ?? '',
      senderId: senderId ?? '',
      senderName: senderName,
      senderAvatar: senderAvatar,
      receiverId: receiverId ?? '',
      content: content ?? '',
      type: _mapStringToMessageType(type),
      status: _mapStringToMessageStatus(status),
      timestamp: timestamp ?? DateTime.now(),
      replyToId: replyToId,
      metadata: metadata,
    );
  }

  // Create from Entity
  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      senderId: entity.senderId,
      senderName: entity.senderName,
      senderAvatar: entity.senderAvatar,
      receiverId: entity.receiverId,
      content: entity.content,
      type: entity.type.name,
      status: entity.status.name,
      timestamp: entity.timestamp,
      replyToId: entity.replyToId,
      metadata: entity.metadata,
    );
  }

  MessageType _mapStringToMessageType(String? type) {
    switch (type?.toLowerCase()) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'file':
        return MessageType.file;
      case 'audio':
        return MessageType.audio;
      case 'video':
        return MessageType.video;
      default:
        return MessageType.text;
    }
  }

  MessageStatus _mapStringToMessageStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'failed':
        return MessageStatus.failed;
      default:
        return MessageStatus.sent;
    }
  }

  @override
  List<Object?> get props => [
    id,
    senderId,
    senderName,
    senderAvatar,
    receiverId,
    content,
    type,
    status,
    timestamp,
    replyToId,
    metadata,
  ];
}
