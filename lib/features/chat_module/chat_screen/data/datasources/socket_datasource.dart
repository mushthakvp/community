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
  Future<MessageModel> sendPersonalMessage({
    required String receiverId,
    required String content,
    String? mediaUrl,
    String? mediaType,
  });
  Stream<MessageModel> listenToNewMessages(String chatId);
  Stream<MessageModel> listenToPersonalMessages();
  Future<void> joinRoom(String chatId);
  Future<void> joinPersonalChat(String friendId);
  Future<void> leaveRoom(String chatId);
  bool get isConnected;
}

class SocketDataSourceImpl implements SocketDataSource {
  IO.Socket? _socket;
  final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();
  final StreamController<MessageModel> _personalMessageController =
      StreamController<MessageModel>.broadcast();

  bool _isConnected = false;
  bool _isConnecting = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 2);

  String? _currentRoomId;
  final Set<String> _joinedRooms = <String>{};

  @override
  bool get isConnected => _isConnected && _socket?.connected == true;

  @override
  Future<void> connect() async {
    if (_isConnecting) return;
    if (isConnected) return;

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
      debugPrint('Socket connected successfully');
      _isConnected = true;
      _reconnectAttempts = 0;
      _cancelReconnectTimer();
      _rejoinAllRooms();
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

    // Group/Community chat message listener
    _socket!.on('message_received_community', (data) {
      try {
        if (data == null) return;

        final rawData = data as Map<String, dynamic>;
        String? messageRoomId;

        if (rawData.containsKey('community') && rawData['community'] != null) {
          messageRoomId = rawData['community'].toString();
        } else if (rawData.containsKey('chatId') && rawData['chatId'] != null) {
          messageRoomId = rawData['chatId'].toString();
        }

        if (messageRoomId == null || messageRoomId.isEmpty) return;

        final messageData = Map<String, dynamic>.from(rawData);
        messageData['chat'] = messageRoomId;
        final message = MessageModel.fromJson(messageData);

        if (_shouldEmitMessage(messageRoomId)) {
          if (!_messageController.isClosed) {
            _messageController.add(message);
          }
        }
      } catch (e, stackTrace) {
        debugPrint('Error in group message listener: $e trace $stackTrace');
      }
    });

    // Personal chat message listener
    _socket!.on('message_received_singleChat', (data) {
      try {
        if (data == null) return;

        final rawData = data as Map<String, dynamic>;
        final currentUserId = StorageService.userId;

        // Extract sender and receiver information
        String? senderId;
        String? chatId;

        if (rawData.containsKey('sender') && rawData['sender'] != null) {
          final sender = rawData['sender'];
          if (sender is Map && sender.containsKey('_id')) {
            senderId = sender['_id'].toString();
          }
        }

        // For personal chat, determine the chat ID
        if (senderId != null) {
          if (senderId == currentUserId) {
            // This is our own message, use receiver as chatId
            if (rawData.containsKey('receiver') &&
                rawData['receiver'] != null) {
              chatId = rawData['receiver'].toString();
            }
          } else {
            // This is incoming message, use sender as chatId
            chatId = senderId;
          }
        }

        if (chatId == null || chatId.isEmpty) return;

        final messageData = Map<String, dynamic>.from(rawData);
        messageData['chat'] = chatId;

        final message = MessageModel.fromJson(messageData);

        if (!_personalMessageController.isClosed) {
          _personalMessageController.add(message);
        }

        // Also add to main message controller for unified handling
        if (!_messageController.isClosed) {
          _messageController.add(message);
        }
      } catch (e, stackTrace) {
        debugPrint(
          'Error in personal chat message listener: $e trace $stackTrace',
        );
      }
    });
  }

  bool _shouldEmitMessage(String messageRoomId) {
    if (_currentRoomId == messageRoomId) return true;
    if (_joinedRooms.contains(messageRoomId)) return true;
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
      debugPrint('Max reconnection attempts reached');
      return;
    }
    _cancelReconnectTimer();
    _reconnectAttempts++;

    final delay = Duration(
      seconds: reconnectDelay.inSeconds * _reconnectAttempts,
    );

    debugPrint(
      'Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s',
    );

    _reconnectTimer = Timer(delay, () {
      if (!isConnected) {
        debugPrint('Attempting to reconnect...');
        _connectToSocket().catchError((e) {
          debugPrint('Reconnection attempt failed: $e');
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
      await _leaveAllRooms();

      if (_socket != null) {
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
      }

      if (!_messageController.isClosed) {
        await _messageController.close();
      }

      if (!_personalMessageController.isClosed) {
        await _personalMessageController.close();
      }
    } catch (e) {
      debugPrint('Error during disconnect: $e');
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

      debugPrint('Sending community message: $data');
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
  Future<MessageModel> sendPersonalMessage({
    required String receiverId,
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
        'chatId': receiverId, // For personal chat, use receiver ID as chat ID
        'token': token,
        'msg': content,
        'media': mediaUrl ?? '',
        'ext': mediaType ?? '',
      };

      debugPrint('Sending personal message: $data');
      _socket!.emit('newMessageSingleChat', data);

      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: receiverId,
        senderId: userId,
        senderName: 'You',
        content: content,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        createdAt: DateTime.now().toLocal(),
        isCurrentUser: true,
      );
    } catch (e) {
      throw Exception('Failed to send personal message: $e');
    }
  }

  @override
  Stream<MessageModel> listenToNewMessages(String chatId) {
    return _messageController.stream.where((message) {
      return message.chatId == chatId;
    });
  }

  @override
  Stream<MessageModel> listenToPersonalMessages() {
    return _personalMessageController.stream;
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

      if (_currentRoomId != null && _currentRoomId != chatId) {
        await leaveRoom(_currentRoomId!);
      }

      _currentRoomId = chatId;
      _joinedRooms.add(chatId);

      debugPrint('Joining community room: $chatId');
      _socket!.emit('setup', {'chatId': chatId, 'token': token});

      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      _joinedRooms.remove(chatId);
      if (_currentRoomId == chatId) {
        _currentRoomId = null;
      }
      throw Exception('Failed to join room: $e');
    }
  }

  @override
  Future<void> joinPersonalChat(String friendId) async {
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

      if (_currentRoomId != null && _currentRoomId != friendId) {
        await leaveRoom(_currentRoomId!);
      }

      _currentRoomId = friendId;
      _joinedRooms.add(friendId);

      debugPrint('Joining personal chat with friend: $friendId');
      _socket!.emit('setup', {'chatId': friendId, 'token': token});

      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      _joinedRooms.remove(friendId);
      if (_currentRoomId == friendId) {
        _currentRoomId = null;
      }
      throw Exception('Failed to join personal chat: $e');
    }
  }

  @override
  Future<void> leaveRoom(String chatId) async {
    if (_socket == null) return;

    try {
      debugPrint('Leaving room: $chatId');
      _socket!.emit('leave', {'chatId': chatId});

      _joinedRooms.remove(chatId);

      if (_currentRoomId == chatId) {
        _currentRoomId = null;
      }
    } catch (e) {
      debugPrint('Error leaving room: $e');
    }
  }

  Future<void> _rejoinAllRooms() async {
    if (_joinedRooms.isEmpty) return;

    final roomsToRejoin = List<String>.from(_joinedRooms);
    for (final roomId in roomsToRejoin) {
      try {
        final token = await StorageService.getToken();
        if (token != null) {
          debugPrint('Rejoining room: $roomId');
          _socket!.emit('setup', {'chatId': roomId, 'token': token});
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } catch (e) {
        debugPrint('Error rejoining room $roomId: $e');
      }
    }
  }

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
}
