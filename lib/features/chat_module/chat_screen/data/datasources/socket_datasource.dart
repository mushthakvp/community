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

  // Track current room to avoid conflicts
  String? _currentRoomId;
  final Set<String> _joinedRooms = <String>{};

  @override
  bool get isConnected => _isConnected && _socket?.connected == true;

  String? get currentRoom => _currentRoomId;

  @override
  Future<void> connect() async {
    if (_isConnecting) {
      return;
    }
    if (isConnected) {
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
    } catch (e) {
      _isConnecting = false;
      _scheduleReconnect();
      rethrow;
    }
  }

  void _setupSocketListeners() {
    _socket!.onConnect((_) {
      _isConnected = true;
      _reconnectAttempts = 0;
      _cancelReconnectTimer();
      _rejoinAllRooms();
    });

    _socket!.onDisconnect((reason) {
      _isConnected = false;
      if (reason != 'io client disconnect') {
        _scheduleReconnect();
      }
    });

    _socket!.onConnectError((error) {
      _isConnected = false;
      _scheduleReconnect();
    });

    _socket!.onError((error) {
      // Error handled silently
    });

    _socket!.on('message_received_community', (data) {
      try {
        if (data == null) {
          return;
        }
        final rawData = data as Map<String, dynamic>;
        String? messageRoomId;
        if (rawData.containsKey('community') &&
            rawData['community'] != null &&
            rawData['community'].toString().isNotEmpty) {
          messageRoomId = rawData['community'].toString();
        } else if (rawData.containsKey('chatId') &&
            rawData['chatId'] != null &&
            rawData['chatId'].toString().isNotEmpty) {
          messageRoomId = rawData['chatId'].toString();
        } else if (rawData.containsKey('communityId') &&
            rawData['communityId'] != null &&
            rawData['communityId'].toString().isNotEmpty) {
          messageRoomId = rawData['communityId'].toString();
        }

        if (messageRoomId == null || messageRoomId.isEmpty) {
          return;
        }
        final messageData = Map<String, dynamic>.from(rawData);
        messageData['chat'] = messageRoomId;
        final message = MessageModel.fromJson(messageData);
        final shouldEmit = _shouldEmitMessage(messageRoomId);
        if (shouldEmit) {
          if (!_messageController.isClosed) {
            _messageController.add(message);
          }
        }
      } catch (e, stackTrace) {
        debugPrint(
          'Error in _socket!.on("message_received_community"): $e trace $stackTrace',
        );
      }
    });

    _socket!.on('userJoinedRoom', (data) {});

    _socket!.on('userLeftRoom', (data) {});

    _socket!.onReconnect((attempt) {
      _isConnected = true;
      _reconnectAttempts = 0;
    });

    _socket!.onReconnectError((error) {});

    _socket!.onReconnectFailed((_) {
      _isConnected = false;
    });
  }

  bool _shouldEmitMessage(String messageRoomId) {
    if (_currentRoomId == messageRoomId) {
      return true;
    }
    if (_joinedRooms.contains(messageRoomId)) {
      return true;
    }
    return false;
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
      return;
    }
    _cancelReconnectTimer();
    _reconnectAttempts++;
    final delay = Duration(
      seconds: reconnectDelay.inSeconds * _reconnectAttempts,
    );
    _reconnectTimer = Timer(delay, () {
      if (!isConnected) {
        _connectToSocket().catchError((e) {});
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
      await _leaveAllRooms();
      if (_socket != null) {
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
      }
      if (!_messageController.isClosed) {
        await _messageController.close();
      }
    } catch (e) {
      // Error handled silently
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
        'communityId': chatId,
        'token': token,
        'msg': content,
        'media': mediaUrl ?? '',
        'ext': mediaType ?? '',
      };
      _socket!.emit('newMessageCommunity', data);

      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: userId,
        senderName: 'You',
        content: content,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        createdAt: DateTime.now().toLocal(),
        isCurrentUser: true,
      );
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Stream<MessageModel> listenToNewMessages(String chatId) {
    return _messageController.stream.where((message) {
      final matches = message.chatId == chatId;
      return matches;
    });
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

      // Leave current room if different
      if (_currentRoomId != null && _currentRoomId != chatId) {
        await leaveRoom(_currentRoomId!);
      }

      // Update tracking before joining
      _currentRoomId = chatId;
      _joinedRooms.add(chatId);

      _socket!.emit('setup', {'chatId': chatId, 'token': token});

      // Wait for the room join to complete
      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      // Remove from tracking if join failed
      _joinedRooms.remove(chatId);
      if (_currentRoomId == chatId) {
        _currentRoomId = null;
      }
      throw Exception('Failed to join room: $e');
    }
  }

  @override
  Future<void> leaveRoom(String chatId) async {
    if (_socket == null) return;

    try {
      _socket!.emit('leave', {'chatId': chatId});

      _joinedRooms.remove(chatId);

      if (_currentRoomId == chatId) {
        _currentRoomId = null;
      }
    } catch (e) {
      // Error handled silently
    }
  }

  // Helper method to rejoin all rooms after reconnection
  Future<void> _rejoinAllRooms() async {
    if (_joinedRooms.isEmpty) return;

    final roomsToRejoin = List<String>.from(_joinedRooms);
    for (final roomId in roomsToRejoin) {
      try {
        // Don't use joinRoom here as it would clear _currentRoomId
        final token = await StorageService.getToken();
        if (token != null) {
          _socket!.emit('setup', {'chatId': roomId, 'token': token});
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } catch (e) {
        // Error handled silently
      }
    }
  }

  // Helper method to leave all rooms
  Future<void> _leaveAllRooms() async {
    final roomsToLeave = List<String>.from(_joinedRooms);
    for (final roomId in roomsToLeave) {
      await leaveRoom(roomId);
    }
    _currentRoomId = null;
  }

  // Add method to manually reconnect
  Future<void> reconnect() async {
    _reconnectAttempts = 0;
    await disconnect();
    await connect();
  }

  // Method to clear all room tracking
  void clearRoomTracking() {
    _joinedRooms.clear();
    _currentRoomId = null;
  }

  // Get list of joined rooms for debugging
  Set<String> get joinedRooms => Set.from(_joinedRooms);
}
