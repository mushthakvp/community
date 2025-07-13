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

  // Track current room to avoid conflicts
  String? _currentRoomId;
  final Set<String> _joinedRooms = <String>{};

  @override
  bool get isConnected => _isConnected && _socket?.connected == true;

  String? get currentRoom => _currentRoomId;

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

      // Rejoin all previously joined rooms
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
      log('Socket error: $error');
    });

    _socket!.on('message_received_community', (data) {
      try {
        debugPrint('Raw socket message received: $data');
        if (data == null) {
          debugPrint('Received null message data');
          return;
        }

        final rawData = data as Map<String, dynamic>;

        // ENHANCED: Handle multiple room ID field variations
        String? messageRoomId;

        // Try different field names for room/chat ID
        if (rawData.containsKey('community') &&
            rawData['community'] != null &&
            rawData['community'].toString().isNotEmpty) {
          messageRoomId = rawData['community'].toString();
          debugPrint('Found community ID: $messageRoomId');
        } else if (rawData.containsKey('chatId') &&
            rawData['chatId'] != null &&
            rawData['chatId'].toString().isNotEmpty) {
          messageRoomId = rawData['chatId'].toString();
          debugPrint('Found chatId: $messageRoomId');
        } else if (rawData.containsKey('communityId') &&
            rawData['communityId'] != null &&
            rawData['communityId'].toString().isNotEmpty) {
          messageRoomId = rawData['communityId'].toString();
          debugPrint('Found communityId: $messageRoomId');
        }

        if (messageRoomId == null || messageRoomId.isEmpty) {
          debugPrint(
            'Message has no valid room ID - ignoring. Available fields: ${rawData.keys.toList()}',
          );
          return;
        }

        // Create message with proper chatId - IMPORTANT: Use the messageRoomId for chat field
        final messageData = Map<String, dynamic>.from(rawData);
        messageData['chat'] = messageRoomId;

        final message = MessageModel.fromJson(messageData);
        debugPrint(
          'Parsed message: ${message.content} from ${message.senderName} for chat ${message.chatId}',
        );

        // FIXED: Check if we should emit this message for the current room
        final shouldEmit = _shouldEmitMessage(messageRoomId);

        debugPrint(
          'Current room: $_currentRoomId, Message room: $messageRoomId, Should emit: $shouldEmit',
        );
        debugPrint('Joined rooms: $_joinedRooms');

        if (shouldEmit) {
          if (!_messageController.isClosed) {
            _messageController.add(message);
            debugPrint(
              'Message added to stream successfully for room: $messageRoomId',
            );
          } else {
            debugPrint('Message controller is closed, cannot add message');
          }
        } else {
          debugPrint(
            'Ignoring message for room we are not in: $messageRoomId (current: $_currentRoomId)',
          );
        }
      } catch (e, stackTrace) {
        debugPrint('Error parsing received message: $e');
        debugPrint('Stack trace: $stackTrace');
        debugPrint('Raw data: $data');
      }
    });

    _socket!.on('userJoinedRoom', (data) {
      debugPrint('User joined room: $data');
    });

    _socket!.on('userLeftRoom', (data) {
      debugPrint('User left room: $data');
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

  // ENHANCED: Better room matching logic
  bool _shouldEmitMessage(String messageRoomId) {
    // Check if the message is for the current active room
    if (_currentRoomId == messageRoomId) {
      return true;
    }

    // Check if we're in this room (for multi-room scenarios)
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

      // Leave all rooms before disconnecting
      await _leaveAllRooms();

      if (_socket != null) {
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
      }

      if (!_messageController.isClosed) {
        await _messageController.close();
      }

      debugPrint('Socket disconnected successfully');
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
        'communityId': chatId,
        'token': token,
        'msg': content,
        'media': mediaUrl ?? '',
        'ext': mediaType ?? '',
      };

      debugPrint('Sending message to room: $chatId');
      debugPrint('Message data: $data');
      _socket!.emit('newMessageCommunity', data);

      return MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: userId,
        senderName: 'You',
        content: content,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        createdAt: DateTime.now().toLocal(), // Use local time
        isCurrentUser: true,
      );
    } catch (e) {
      debugPrint('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Stream<MessageModel> listenToNewMessages(String chatId) {
    debugPrint('Setting up message listener for chat: $chatId');
    return _messageController.stream.where((message) {
      final matches = message.chatId == chatId;
      if (!matches) {
        debugPrint(
          'Filtering out message for different chat: ${message.chatId} (expected: $chatId)',
        );
      }
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
        debugPrint('Leaving previous room: $_currentRoomId');
        await leaveRoom(_currentRoomId!);
      }

      // Update tracking before joining
      _currentRoomId = chatId;
      _joinedRooms.add(chatId);

      debugPrint('Joining room: $chatId with token');
      _socket!.emit('setup', {'chatId': chatId, 'token': token});

      // Wait for the room join to complete
      await Future.delayed(const Duration(milliseconds: 1000));
      debugPrint('Successfully joined room: $chatId');
      debugPrint('Current room now: $_currentRoomId');
      debugPrint('Joined rooms: $_joinedRooms');
    } catch (e) {
      debugPrint('Failed to join room: $e');
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
      debugPrint('Leaving room: $chatId');
      _socket!.emit('leave', {'chatId': chatId});

      _joinedRooms.remove(chatId);

      if (_currentRoomId == chatId) {
        _currentRoomId = null;
      }

      debugPrint('Successfully left room: $chatId');
      debugPrint('Current room now: $_currentRoomId');
      debugPrint('Joined rooms: $_joinedRooms');
    } catch (e) {
      debugPrint('Error leaving room: $e');
    }
  }

  // Helper method to rejoin all rooms after reconnection
  Future<void> _rejoinAllRooms() async {
    if (_joinedRooms.isEmpty) return;

    debugPrint('Rejoining ${_joinedRooms.length} rooms after reconnection');

    final roomsToRejoin = List<String>.from(_joinedRooms);
    for (final roomId in roomsToRejoin) {
      try {
        // Don't use joinRoom here as it would clear _currentRoomId
        final token = await StorageService.getToken();
        if (token != null) {
          debugPrint('Rejoining room: $roomId');
          _socket!.emit('setup', {'chatId': roomId, 'token': token});
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } catch (e) {
        debugPrint('Failed to rejoin room $roomId: $e');
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
    debugPrint('Manual reconnection requested');
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
