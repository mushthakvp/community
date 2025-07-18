import 'dart:convert';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../../../chat_screen/data/models/message_model.dart';
import '../models/personal_chat_model.dart';

abstract class PersonalChatRemoteDataSource {
  Future<List<PersonalChatModel>> getPersonalChats();
  Future<PersonalChatModel> getPersonalChat(String userId);
  Future<List<MessageModel>> getPersonalChatMessages(String userId);
  Future<Map<String, dynamic>> getPersonalChatWithMessages(String userId);
}

class PersonalChatRemoteDataSourceImpl implements PersonalChatRemoteDataSource {
  final ApiClient apiClient;

  // Cache for personal chat info
  final Map<String, PersonalChatModel> _personalChatCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheTimeout = Duration(minutes: 5);

  PersonalChatRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PersonalChatModel>> getPersonalChats() async {
    final response = await apiClient.get(
      '${ChatApiConstants.getMyGroupData}?type=friends',
    );

    final data = jsonDecode(response.body);
    final chatsJson = data['data'] as List<dynamic>;

    return chatsJson.map((json) => PersonalChatModel.fromJson(json)).toList();
  }

  @override
  Future<PersonalChatModel> getPersonalChat(String userId) async {
    // Check cache first
    if (_isCacheValid(userId)) {
      return _personalChatCache[userId]!;
    }

    final response = await apiClient.get(
      '${ChatApiConstants.getSingleChat}?friendId=$userId',
    );

    final data = jsonDecode(response.body);
    final chat = PersonalChatModel.fromJson(data['chat']);

    // Cache the result
    _cacheResult(userId, chat);

    return chat;
  }

  @override
  Future<List<MessageModel>> getPersonalChatMessages(String userId) async {
    final response = await apiClient.get(
      '${ChatApiConstants.fetchAllMessagesSingleChat}$userId',
    );

    final data = jsonDecode(response.body);
    final messagesJson = data['messages'] as List<dynamic>;

    return messagesJson.map((json) => MessageModel.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> getPersonalChatWithMessages(
    String userId,
  ) async {
    final response = await apiClient.get(
      '${ChatApiConstants.fetchAllMessagesSingleChat}$userId',
    );

    final data = jsonDecode(response.body);

    // Extract chat and messages from response
    final chatData = data['chat'] as Map<String, dynamic>;
    final messagesJson = data['messages'] as List<dynamic>;

    final chat = PersonalChatModel.fromJson(chatData);
    final messages = messagesJson
        .map((json) => MessageModel.fromJson(json))
        .toList();

    // Cache the chat info
    _cacheResult(userId, chat);

    return {'chat': chat, 'messages': messages};
  }

  bool _isCacheValid(String userId) {
    if (!_personalChatCache.containsKey(userId)) return false;
    final timestamp = _cacheTimestamps[userId];
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < _cacheTimeout;
  }

  void _cacheResult(String userId, PersonalChatModel chat) {
    _personalChatCache[userId] = chat;
    _cacheTimestamps[userId] = DateTime.now();
    _cleanOldCache();
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
      _personalChatCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  void clearCache() {
    _personalChatCache.clear();
    _cacheTimestamps.clear();
  }
}
