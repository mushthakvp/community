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

    _socket!.onError((error) {
      debugPrint('Socket error: $error');
    });

    // Group/Community chat message listener
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

    // Personal chat message listener
    _socket!.on('message_received_singleChat', (data) {
      try {
        if (data == null) return;

        final rawData = data as Map<String, dynamic>;

        // For personal chat, determine chat ID from sender/receiver
        String? chatId;
        String? senderId;
        String? currentUserId = StorageService.userId;

        if (rawData.containsKey('sender') && rawData['sender'] != null) {
          final sender = rawData['sender'];
          if (sender is Map && sender.containsKey('_id')) {
            senderId = sender['_id'].toString();
          }
        }

        // For personal chat, use the other user's ID as chatId
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

        if (!_messageController.isClosed) {
          _messageController.add(message);
        }
      } catch (e, stackTrace) {
        debugPrint(
          'Error in personal chat message listener: $e trace $stackTrace',
        );
      }
    });

    _socket!.on('userJoinedRoom', (data) {
      debugPrint('User joined room: $data');
    });

    _socket!.on('userLeftRoom', (data) {
      debugPrint('User left room: $data');
    });

    _socket!.onReconnect((attempt) {
      debugPrint('Socket reconnected on attempt: $attempt');
      _isConnected = true;
      _reconnectAttempts = 0;
    });

    _socket!.onReconnectError((error) {
      debugPrint('Socket reconnection error: $error');
    });

    _socket!.onReconnectFailed((_) {
      debugPrint('Socket reconnection failed after all attempts');
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
        'friendId': receiverId,
        'token': token,
        'msg': content,
        'media': mediaUrl ?? '',
        'ext': mediaType ?? '',
      };

      debugPrint('Sending personal message: $data');
      _socket!.emit('newMessageSingleChat', data);

      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: receiverId, // For personal chat, use receiver ID as chat ID
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
      final matches = message.chatId == chatId;
      return matches;
    });
  }

  @override
  Stream<MessageModel> listenToPersonalMessages() {
    return _messageController.stream.where((message) {
      // Personal messages can be identified by checking if it's not a group/community
      // This is a simplified approach - you might need to adjust based on your backend
      return !message.chatId.contains('group') &&
          !message.chatId.contains('community') &&
          message.chatId.length < 30; // Assuming personal chat IDs are shorter
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

      debugPrint('Joining community room: $chatId');
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

      // Leave current room if different
      if (_currentRoomId != null && _currentRoomId != friendId) {
        await leaveRoom(_currentRoomId!);
      }

      // Update tracking before joining
      _currentRoomId = friendId;
      _joinedRooms.add(friendId);

      debugPrint('Joining personal chat with friend: $friendId');
      _socket!.emit('setup', {'friendId': friendId, 'token': token});

      await Future.delayed(const Duration(milliseconds: 1000));
    } catch (e) {
      // Remove from tracking if join failed
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

  // Helper method to rejoin all rooms after reconnection
  Future<void> _rejoinAllRooms() async {
    if (_joinedRooms.isEmpty) return;

    final roomsToRejoin = List<String>.from(_joinedRooms);
    for (final roomId in roomsToRejoin) {
      try {
        final token = await StorageService.getToken();
        if (token != null) {
          // Determine if it's a personal chat or group chat
          // This is a simplified approach - adjust based on your ID patterns
          if (roomId.length < 30) {
            // Assume it's a personal chat (shorter IDs)
            debugPrint('Rejoining personal chat: $roomId');
            _socket!.emit('setup', {'friendId': roomId, 'token': token});
          } else {
            // Assume it's a group/community chat
            debugPrint('Rejoining community room: $roomId');
            _socket!.emit('setup', {'chatId': roomId, 'token': token});
          }
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } catch (e) {
        debugPrint('Error rejoining room $roomId: $e');
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

  // Method to check if currently in a specific room
  bool isInRoom(String roomId) {
    return _joinedRooms.contains(roomId);
  }

  // Method to get connection status info
  Map<String, dynamic> getConnectionInfo() {
    return {
      'isConnected': isConnected,
      'isConnecting': _isConnecting,
      'reconnectAttempts': _reconnectAttempts,
      'currentRoom': _currentRoomId,
      'joinedRooms': _joinedRooms.toList(),
      'socketConnected': _socket?.connected ?? false,
    };
  }

  // Method to force emit a test message (for debugging)
  void sendTestMessage() {
    if (isConnected) {
      _socket!.emit('test', {
        'message': 'Test from client',
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  // Method to listen for specific events (for debugging)
  void listenForEvent(String eventName, Function(dynamic) callback) {
    _socket?.on(eventName, callback);
  }

  // Method to emit custom events
  void emitEvent(String eventName, Map<String, dynamic> data) {
    if (isConnected) {
      _socket!.emit(eventName, data);
    }
  }
}
