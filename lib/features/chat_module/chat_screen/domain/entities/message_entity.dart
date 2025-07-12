import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String content;
  final String? mediaUrl;
  final String? mediaType;
  final DateTime createdAt;
  final bool isDeleted;
  final bool isCurrentUser;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.content,
    this.mediaUrl,
    this.mediaType,
    required this.createdAt,
    this.isDeleted = false,
    this.isCurrentUser = false,
  });

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    senderName,
    senderImage,
    content,
    mediaUrl,
    mediaType,
    createdAt,
    isDeleted,
    isCurrentUser,
  ];
}
