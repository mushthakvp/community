import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../chat_screen/domain/entities/chat_entity.dart';
import '../../chat_screen/domain/entities/message_entity.dart';

class ChatCacheManager {
  static const String _cacheFileName = 'chat_cache.json';

  static File? _cacheFile;
  static Map<String, ChatCacheData>? _memoryCache;

  // Initialize cache manager
  static Future<void> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _cacheFile = File('${directory.path}/$_cacheFileName');
      await _loadCacheFromDisk();
    } catch (e) {
      debugPrint('Error initializing chat cache: $e');
      _memoryCache = <String, ChatCacheData>{};
    }
  }

  // Load cache from disk
  static Future<void> _loadCacheFromDisk() async {
    try {
      if (_cacheFile?.existsSync() == true) {
        final jsonString = await _cacheFile!.readAsString();
        final Map<String, dynamic> jsonData = json.decode(jsonString);

        _memoryCache = <String, ChatCacheData>{};
        jsonData.forEach((key, value) {
          try {
            final cacheData = ChatCacheData.fromJson(value);
            if (!cacheData.isExpired()) {
              _memoryCache![key] = cacheData;
            }
          } catch (e) {
            debugPrint('Error parsing cache data for $key: $e');
          }
        });

        debugPrint('Loaded ${_memoryCache!.length} chats from cache');
      } else {
        _memoryCache = <String, ChatCacheData>{};
      }
    } catch (e) {
      debugPrint('Error loading cache from disk: $e');
      _memoryCache = <String, ChatCacheData>{};
    }
  }

  // Save cache to disk
  static Future<void> _saveCacheToDisk() async {
    try {
      if (_cacheFile == null || _memoryCache == null) return;

      final Map<String, dynamic> jsonData = {};
      _memoryCache!.forEach((key, value) {
        if (!value.isExpired()) {
          jsonData[key] = value.toJson();
        }
      });

      final jsonString = json.encode(jsonData);
      await _cacheFile!.writeAsString(jsonString);
      debugPrint('Saved ${jsonData.length} chats to cache');
    } catch (e) {
      debugPrint('Error saving cache to disk: $e');
    }
  }

  // Get cached chat data
  static ChatCacheData? getCachedChat(String chatId) {
    if (_memoryCache == null) return null;

    final cached = _memoryCache![chatId];
    if (cached != null && cached.isExpired()) {
      _memoryCache!.remove(chatId);
      return null;
    }

    return cached;
  }

  // Cache chat data
  static Future<void> cacheChat({
    required String chatId,
    required ChatEntity chat,
    required List<MessageEntity> messages,
  }) async {
    if (_memoryCache == null) return;

    final cacheData = ChatCacheData(
      chat: chat,
      messages: List.from(messages),
      lastUpdated: DateTime.now(),
    );

    _memoryCache![chatId] = cacheData;

    // Save to disk periodically (not on every update for performance)
    if (_memoryCache!.length % 5 == 0) {
      await _saveCacheToDisk();
    }
  }

  // Update cached messages for a chat
  static Future<void> updateCachedMessages(
    String chatId,
    List<MessageEntity> messages,
  ) async {
    if (_memoryCache == null) return;

    final existing = _memoryCache![chatId];
    if (existing != null) {
      existing.messages.clear();
      existing.messages.addAll(messages);
      existing.lastUpdated = DateTime.now();
    }
  }

  // Add a single message to cache
  static void addMessageToCache(String chatId, MessageEntity message) {
    if (_memoryCache == null) return;

    final existing = _memoryCache![chatId];
    if (existing != null) {
      // Check if message already exists
      final existingIndex = existing.messages.indexWhere(
        (m) => m.id == message.id,
      );
      if (existingIndex != -1) {
        existing.messages[existingIndex] = message;
      } else {
        existing.messages.add(message);
      }
      existing.lastUpdated = DateTime.now();
    }
  }

  // Remove chat from cache
  static Future<void> removeCachedChat(String chatId) async {
    if (_memoryCache == null) return;

    _memoryCache!.remove(chatId);
    await _saveCacheToDisk();
  }

  // Clear all cache
  static Future<void> clearAllCache() async {
    _memoryCache?.clear();
    try {
      if (_cacheFile?.existsSync() == true) {
        await _cacheFile!.delete();
      }
    } catch (e) {
      debugPrint('Error clearing cache file: $e');
    }
  }

  // Clear expired cache entries
  static Future<void> clearExpiredCache() async {
    if (_memoryCache == null) return;

    final keysToRemove = <String>[];
    _memoryCache!.forEach((key, value) {
      if (value.isExpired()) {
        keysToRemove.add(key);
      }
    });

    for (final key in keysToRemove) {
      _memoryCache!.remove(key);
    }

    if (keysToRemove.isNotEmpty) {
      await _saveCacheToDisk();
      debugPrint('Cleared ${keysToRemove.length} expired cache entries');
    }
  }

  // Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    if (_memoryCache == null) {
      return {
        'totalChats': 0,
        'totalMessages': 0,
        'cacheSize': '0 KB',
        'oldestEntry': null,
        'newestEntry': null,
      };
    }

    int totalMessages = 0;
    DateTime? oldest;
    DateTime? newest;

    _memoryCache!.forEach((key, value) {
      totalMessages += value.messages.length;

      if (oldest == null || value.lastUpdated.isBefore(oldest!)) {
        oldest = value.lastUpdated;
      }

      if (newest == null || value.lastUpdated.isAfter(newest!)) {
        newest = value.lastUpdated;
      }
    });

    return {
      'totalChats': _memoryCache!.length,
      'totalMessages': totalMessages,
      'cacheSize': '${(_estimateCacheSize() / 1024).toStringAsFixed(1)} KB',
      'oldestEntry': oldest?.toIso8601String(),
      'newestEntry': newest?.toIso8601String(),
    };
  }

  // Estimate cache size in bytes
  static int _estimateCacheSize() {
    if (_memoryCache == null) return 0;

    try {
      final jsonString = json.encode(
        _memoryCache!.map((key, value) => MapEntry(key, value.toJson())),
      );
      return jsonString.length;
    } catch (e) {
      return 0;
    }
  }

  // Force save cache to disk
  static Future<void> forceSave() async {
    await _saveCacheToDisk();
  }

  // Check if chat is cached
  static bool isChatCached(String chatId) {
    if (_memoryCache == null) return false;
    final cached = _memoryCache![chatId];
    return cached != null && !cached.isExpired();
  }

  // Get all cached chat IDs
  static List<String> getCachedChatIds() {
    if (_memoryCache == null) return [];
    return _memoryCache!.keys.where((key) {
      final cached = _memoryCache![key];
      return cached != null && !cached.isExpired();
    }).toList();
  }
}

// Enhanced cache data class with serialization
class ChatCacheData {
  final ChatEntity chat;
  final List<MessageEntity> messages;
  DateTime lastUpdated;

  ChatCacheData({
    required this.chat,
    required this.messages,
    required this.lastUpdated,
  });

  bool isExpired({Duration maxAge = const Duration(hours: 24)}) {
    return DateTime.now().difference(lastUpdated) > maxAge;
  }

  Map<String, dynamic> toJson() {
    return {
      'chat': _chatToJson(chat),
      'messages': messages.map((m) => _messageToJson(m)).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory ChatCacheData.fromJson(Map<String, dynamic> json) {
    return ChatCacheData(
      chat: _chatFromJson(json['chat']),
      messages: (json['messages'] as List)
          .map((m) => _messageFromJson(m))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  // Helper methods for serialization
  static Map<String, dynamic> _chatToJson(ChatEntity chat) {
    return {
      'id': chat.id,
      'users': chat.users
          .map(
            (u) => {
              'id': u.id,
              'name': u.name,
              'profileImage': u.profileImage,
              'district': u.district,
              'isOnline': u.isOnline,
            },
          )
          .toList(),
      'latestMessage': chat.latestMessage,
      'lastMessageTime': chat.lastMessageTime?.toIso8601String(),
      'isGroup': chat.isGroup,
      'groupName': chat.groupName,
      'groupImage': chat.groupImage,
      'wallpaper': chat.wallpaper,
      'isBot': chat.isBot,
      'role': chat.role,
      'unreadCount': chat.unreadCount,
      'isCreator': chat.isCreator,
      'isUserInGroup': chat.isUserInGroup,
      'isUserRequested': chat.isUserRequested,
      'shareLink': chat.shareLink,
    };
  }

  static ChatEntity _chatFromJson(Map<String, dynamic> json) {
    return ChatEntity(
      id: json['id'],
      users: [], // Simplified for cache
      latestMessage: json['latestMessage'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      isGroup: json['isGroup'] ?? false,
      groupName: json['groupName'],
      groupImage: json['groupImage'],
      wallpaper: json['wallpaper'],
      isBot: json['isBot'] ?? false,
      role: json['role'],
      unreadCount: json['unreadCount'] ?? 0,
      isCreator: json['isCreator'] ?? false,
      isUserInGroup: json['isUserInGroup'] ?? false,
      isUserRequested: json['isUserRequested'] ?? false,
      shareLink: json['shareLink'],
    );
  }

  static Map<String, dynamic> _messageToJson(MessageEntity message) {
    return {
      'id': message.id,
      'chatId': message.chatId,
      'senderId': message.senderId,
      'senderName': message.senderName,
      'senderImage': message.senderImage,
      'content': message.content,
      'mediaUrl': message.mediaUrl,
      'mediaType': message.mediaType,
      'createdAt': message.createdAt.toIso8601String(),
      'isDeleted': message.isDeleted,
      'isCurrentUser': message.isCurrentUser,
    };
  }

  static MessageEntity _messageFromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderImage: json['senderImage'],
      content: json['content'],
      mediaUrl: json['mediaUrl'],
      mediaType: json['mediaType'],
      createdAt: DateTime.parse(json['createdAt']),
      isDeleted: json['isDeleted'] ?? false,
      isCurrentUser: json['isCurrentUser'] ?? false,
    );
  }
}
