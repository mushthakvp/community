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
  IO.Socket? _socket; // Changed from late to nullable
  final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();
  bool _isConnected = false;

  @override
  Future<void> connect() async {
    try {
      // Disconnect any existing socket
      if (_socket != null) {
        _socket!.disconnect();
        _socket = null;
      }

      _socket = IO.io(
        ChatApiConstants.chatSocketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .build(),
      );

      _socket!.onConnect((_) {
        debugPrint('Socket connected successfully');
        _isConnected = true;
      });
      _socket!.onDisconnect((_) {
        debugPrint('Socket disconnected');
        _isConnected = false;
      });
      _socket!.onConnectError((error) {
        debugPrint('Socket connection error: $error');
        _isConnected = false;
      });
      _socket!.onError((error) {
        debugPrint('Socket error: $error');
      });
      _socket!.on('message_received_singleChat', (data) {
        try {
          final message = MessageModel.fromJson(data);
          _messageController.add(message);
        } catch (e) {
          debugPrint('Error parsing received message: $e');
        }
      });
      _socket!.connect();
      await _waitForConnection();
    } catch (e) {
      debugPrint('Failed to connect socket: $e');
      throw Exception('Socket connection failed: $e');
    }
  }

  Future<void> _waitForConnection() async {
    int attempts = 0;
    const maxAttempts = 10;
    const delayMs = 500;

    while (!_isConnected && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: delayMs));
      attempts++;
    }

    if (!_isConnected) {
      throw Exception(
        'Socket connection timeout after ${maxAttempts * delayMs}ms',
      );
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      if (_socket != null) {
        _socket!.disconnect();
        _socket = null;
      }
      _isConnected = false;
      await _messageController.close();
    } catch (e) {
      debugPrint('Error disconnecting socket: $e');
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  }) async {
    if (_socket == null || !_isConnected) {
      throw Exception('Socket not connected. Please wait for connection.');
    }
    try {
      final token = await StorageService.getToken();
      final userId = await StorageService.getUserId();
      if (token == null || userId == null) {
        throw Exception('User not authenticated');
      }
      final data = {
        'chatId': chatId,
        'token': token,
        'msg': content,
        'media': mediaUrl ?? '',
        'ext': mediaType ?? '',
      };
      debugPrint('Sending message: $data');
      _socket!.emit('newMessageSingleChat', data);
      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: userId,
        senderName: 'You',
        content: content,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        createdAt: DateTime.now(),
        isCurrentUser: true,
      );
    } catch (e) {
      debugPrint('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Stream<MessageModel> listenToNewMessages(String chatId) {
    return _messageController.stream;
  }

  @override
  Future<void> joinRoom(String chatId) async {
    if (_socket == null || !_isConnected) {
      throw Exception('Socket not connected');
    }

    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('Joining room: $chatId');
      _socket!.emit('setup', {'chatId': chatId, 'token': token});
    } catch (e) {
      debugPrint('Error joining room: $e');
      throw Exception('Failed to join room: $e');
    }
  }

  @override
  Future<void> leaveRoom(String chatId) async {
    if (_socket == null) return;

    try {
      debugPrint('Leaving room: $chatId');
      _socket!.emit('leave', {'chatId': chatId});
    } catch (e) {
      debugPrint('Error leaving room: $e');
    }
  }

  bool get isConnected => _isConnected;

  Future<void> reconnect() async {
    if (_socket != null) {
      _socket!.disconnect();
    }
    await connect();
  }
}
