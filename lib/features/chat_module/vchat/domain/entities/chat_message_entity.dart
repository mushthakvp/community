import 'package:equatable/equatable.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String receiverId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final String? replyToId;
  final Map<String, dynamic>? metadata;

  const ChatMessageEntity({
    required this.id,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.receiverId,
    required this.content,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    required this.timestamp,
    this.replyToId,
    this.metadata,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? receiverId,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? replyToId,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      replyToId: replyToId ?? this.replyToId,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isText => type == MessageType.text;
  bool get isImage => type == MessageType.image;
  bool get isFile => type == MessageType.file;
  bool get isAudio => type == MessageType.audio;
  bool get hasReply => replyToId != null;
  bool get isDelivered => status == MessageStatus.delivered;
  bool get isRead => status == MessageStatus.read;
  String get displayContent => content.isNotEmpty ? content : 'Media message';

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

enum MessageType { text, image, file, audio, video }

enum MessageStatus { sending, sent, delivered, read, failed }
