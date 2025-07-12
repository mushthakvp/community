import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/services/storage_service.dart';
import '../models/message_model.dart';

abstract class SocketDataSource {
  Future<void> connect();
  Future<void> disconnect();
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  });
  Stream<MessageModel> listenToNewMessages(String chatId);
  Future<void> joinRoom(String chatId);
  Future<void> leaveRoom(String chatId);
}

class SocketDataSourceImpl implements SocketDataSource {
  late IO.Socket _socket;
  final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();

  @override
  Future<void> connect() async {
    _socket = IO.io(
      ChatApiConstants.chatBaseUrl,
      IO.OptionBuilder().setTransports(['websocket']).build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      debugPrint('Socket connected');
    });

    _socket.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });

    _socket.on('message_received_singleChat', (data) {
      final message = MessageModel.fromJson(data);
      _messageController.add(message);
    });
  }

  @override
  Future<void> disconnect() async {
    _socket.disconnect();
    await _messageController.close();
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  }) async {
    final token = await StorageService.getToken();
    final data = {
      'chatId': chatId,
      'token': token,
      'msg': content,
      'media': mediaUrl ?? '',
      'ext': mediaType ?? '',
    };

    _socket.emit('newMessageSingleChat', data);

    // Return a temporary message model
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: await StorageService.getUserId() ?? '',
      senderName: 'You',
      content: content,
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      createdAt: DateTime.now(),
      isCurrentUser: true,
    );
  }

  @override
  Stream<MessageModel> listenToNewMessages(String chatId) {
    return _messageController.stream;
  }

  @override
  Future<void> joinRoom(String chatId) async {
    final token = await StorageService.getToken();
    _socket.emit('setup', {'chatId': chatId, 'token': token});
  }

  @override
  Future<void> leaveRoom(String chatId) async {
    _socket.emit('leave', {'chatId': chatId});
  }
}
