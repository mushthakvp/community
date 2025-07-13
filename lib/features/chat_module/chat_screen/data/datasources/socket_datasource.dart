import 'dart:async';
import 'dart:developer';

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
  bool get isConnected;
}

class SocketDataSourceImpl implements SocketDataSource {
  IO.Socket? _socket;
  final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();
  bool _isConnected = false;
  bool _isConnecting = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 2);

  @override
  bool get isConnected => _isConnected && _socket?.connected == true;

  @override
  Future<void> connect() async {
    if (_isConnecting) {
      debugPrint('Socket connection already in progress');
      return;
    }
    if (isConnected) {
      debugPrint('Socket already connected');
      return;
    }
    _isConnecting = true;
    try {
      await _connectToSocket();
    } catch (e) {
      _isConnecting = false;
      rethrow;
    }
  }

  Future<void> _connectToSocket() async {
    try {
      if (_socket != null) {
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
      }
      _socket = IO.io(
        ChatApiConstants.chatSocketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(3)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setTimeout(10000)
            .build(),
      );
      _setupSocketListeners();
      _socket!.connect();
      await _waitForConnection();
      _isConnecting = false;
      _reconnectAttempts = 0;
      debugPrint('Socket connected successfully');
    } catch (e) {
      _isConnecting = false;
      debugPrint('Socket connection error: $e');
      _scheduleReconnect();
      rethrow;
    }
  }

  void _setupSocketListeners() {
    _socket!.onConnect((_) {
      debugPrint('Socket connected successfully');
      _isConnected = true;
      _reconnectAttempts = 0;
      _cancelReconnectTimer();
    });

    _socket!.onDisconnect((reason) {
      debugPrint('Socket disconnected: $reason');
      _isConnected = false;
      if (reason != 'io client disconnect') {
        _scheduleReconnect();
      }
    });

    _socket!.onConnectError((error) {
      debugPrint('Socket connection error: $error');
      _isConnected = false;
      _scheduleReconnect();
    });

    _socket!.onError((error) {
      log('Socket error: $error');
    });

    _socket!.on('message_received_singleChat', (data) {
      try {
        debugPrint('Received message: $data');
        final message = MessageModel.fromJson(data);
        _messageController.add(message);
      } catch (e) {
        debugPrint('Error parsing received message: $e');
      }
    });

    _socket!.onReconnect((attempt) {
      debugPrint('Socket reconnected after $attempt attempts');
      _isConnected = true;
      _reconnectAttempts = 0;
    });

    _socket!.onReconnectError((error) {
      debugPrint('Socket reconnection error: $error');
    });

    _socket!.onReconnectFailed((_) {
      debugPrint('Socket reconnection failed after maximum attempts');
      _isConnected = false;
    });
  }

  Future<void> _waitForConnection() async {
    int attempts = 0;
    const maxAttempts = 20;
    const delayMs = 500;

    while (!_isConnected &&
        attempts < maxAttempts &&
        _socket?.connected != true) {
      await Future.delayed(const Duration(milliseconds: delayMs));
      attempts++;
    }

    if (!_isConnected && _socket?.connected != true) {
      throw Exception(
        'Socket connection timeout after ${maxAttempts * delayMs}ms',
      );
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      debugPrint('Maximum reconnection attempts reached');
      return;
    }
    _cancelReconnectTimer();
    _reconnectAttempts++;
    final delay = Duration(
      seconds: reconnectDelay.inSeconds * _reconnectAttempts,
    );
    debugPrint(
      'Scheduling reconnection attempt $_reconnectAttempts in ${delay.inSeconds} seconds',
    );

    _reconnectTimer = Timer(delay, () {
      if (!isConnected) {
        debugPrint(
          'Attempting reconnection $_reconnectAttempts/$maxReconnectAttempts',
        );
        _connectToSocket().catchError((e) {
          debugPrint('Reconnection attempt $_reconnectAttempts failed: $e');
        });
      }
    });
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  @override
  Future<void> disconnect() async {
    try {
      _cancelReconnectTimer();
      _isConnected = false;
      _isConnecting = false;

      if (_socket != null) {
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
      }

      if (!_messageController.isClosed) {
        await _messageController.close();
      }
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
    if (!isConnected) {
      await connect();
      if (!isConnected) {
        throw Exception(
          'Socket not connected. Please check your internet connection.',
        );
      }
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
    if (!isConnected) {
      await connect();
      if (!isConnected) {
        throw Exception('Socket not connected');
      }
    }
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }
      debugPrint('Joining room: $chatId');
      _socket!.emit('setup', {'chatId': chatId, 'token': token});
    } catch (e) {
      log('Error joining room: $e');
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

  Future<void> reconnect() async {
    debugPrint('Manual reconnection requested');
    _reconnectAttempts = 0;
    await disconnect();
    await connect();
  }
}
