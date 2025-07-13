import 'dart:convert';
import 'dart:io';

import 'package:livera/core/services/cloudinary_service.dart';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> getChat(String chatId);
  Future<List<MessageModel>> getMessages(String chatId);
  Future<String> uploadMedia(String filePath);
  Future<void> markMessageAsRead(String messageId);
  Future<void> joinGroup(String chatId);
  Future<Map<String, dynamic>> getChatWithMessages(String chatId);
  Future<Map<String, dynamic>> getChatWithMessagesOptimized(String chatId);
  Future<ChatModel> getChatBasicInfo(String chatId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  final Map<String, ChatModel> _chatInfoCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheTimeout = Duration(minutes: 5);

  ChatRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ChatModel> getChat(String chatId) async {
    if (_isCacheValid(chatId)) {
      return _chatInfoCache[chatId]!;
    }
    final response = await apiClient.get(
      '${ChatApiConstants.getSingleChat}?friendId=$chatId',
    );
    final data = jsonDecode(response.body);
    final chat = ChatModel.fromJson(data['chat']);
    _cacheResult(chatId, chat);
    return chat;
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    final response = await apiClient.get(
      '${ChatApiConstants.enterChat}$chatId',
    );
    final data = jsonDecode(response.body);
    final messagesJson = data['messages'] as List<dynamic>;
    return messagesJson.map((json) => MessageModel.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> getChatWithMessages(String chatId) async {
    final response = await apiClient.get(
      '${ChatApiConstants.enterChat}$chatId',
    );
    final data = jsonDecode(response.body);
    final responseData = data['data'] ?? data;
    final groupDetails = responseData['groupDetails'] as Map<String, dynamic>;
    final messagesJson = responseData['messages'] as List<dynamic>;

    final chat = ChatModel.fromJson(groupDetails);
    final messages = messagesJson
        .map((json) => MessageModel.fromJson(json))
        .toList();

    // Cache the chat info
    _cacheResult(chatId, chat);

    return {'chat': chat, 'messages': messages};
  }

  @override
  Future<Map<String, dynamic>> getChatWithMessagesOptimized(
    String chatId,
  ) async {
    try {
      if (_isCacheValid(chatId)) {
        final cachedChat = _chatInfoCache[chatId]!;
        final messagesFuture = getMessages(chatId);
        final messages = await messagesFuture;
        return {'chat': cachedChat, 'messages': messages};
      }
      return await getChatWithMessages(chatId);
    } catch (e) {
      return await getChatWithMessages(chatId);
    }
  }

  @override
  Future<ChatModel> getChatBasicInfo(String chatId) async {
    if (_isCacheValid(chatId)) {
      return _chatInfoCache[chatId]!;
    }
    try {
      final response = await apiClient.get(
        '${ChatApiConstants.getSingleChat}?friendId=$chatId&basic=true',
      );
      final data = jsonDecode(response.body);
      final chat = ChatModel.fromJson(data['chat']);
      _cacheResult(chatId, chat);
      return chat;
    } catch (e) {
      return await getChat(chatId);
    }
  }

  @override
  Future<String> uploadMedia(String filePath) async {
    File file = File(filePath);
    String? url = await CloudinaryService.uploadSingleImage(file: file);
    return url ?? "";
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    await apiClient.post(
      '${ChatApiConstants.fetchAllMessagesSingleChat}/read',
      body: {'messageId': messageId},
    );
  }

  @override
  Future<void> joinGroup(String chatId) async {
    await apiClient.post('${ChatApiConstants.joinCommunity}$chatId');
    _invalidateCache(chatId);
  }

  bool _isCacheValid(String chatId) {
    if (!_chatInfoCache.containsKey(chatId)) return false;
    final timestamp = _cacheTimestamps[chatId];
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < _cacheTimeout;
  }

  void _cacheResult(String chatId, ChatModel chat) {
    _chatInfoCache[chatId] = chat;
    _cacheTimestamps[chatId] = DateTime.now();
    _cleanOldCache();
  }

  void _invalidateCache(String chatId) {
    _chatInfoCache.remove(chatId);
    _cacheTimestamps.remove(chatId);
  }

  void _cleanOldCache() {
    final now = DateTime.now();
    final keysToRemove = <String>[];
    _cacheTimestamps.forEach((key, timestamp) {
      if (now.difference(timestamp) > _cacheTimeout) {
        keysToRemove.add(key);
      }
    });
    for (final key in keysToRemove) {
      _chatInfoCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  void clearCache() {
    _chatInfoCache.clear();
    _cacheTimestamps.clear();
  }
}
