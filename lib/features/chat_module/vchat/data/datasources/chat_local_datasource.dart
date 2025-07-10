import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message_model.dart';
import '../models/community_model.dart';
import '../models/friend_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheCommunities(List<CommunityModel> communities);
  Future<List<CommunityModel>?> getCachedCommunities();
  Future<void> cacheFriends(List<FriendModel> friends);
  Future<List<FriendModel>?> getCachedFriends();
  Future<void> cacheMessages(String chatId, List<ChatMessageModel> messages);
  Future<List<ChatMessageModel>?> getCachedMessages(String chatId);
  Future<void> clearCache();
  Future<void> cacheLastSyncTime(String key, DateTime timestamp);
  Future<DateTime?> getLastSyncTime(String key);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final SharedPreferences _prefs;

  static const String _communitiesKey = 'cached_communities';
  static const String _friendsKey = 'cached_friends';
  static const String _messagesKeyPrefix = 'cached_messages_';
  static const String _syncTimePrefix = 'sync_time_';

  ChatLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> cacheCommunities(List<CommunityModel> communities) async {
    try {
      final communitiesJson = communities.map((c) => c.toJson()).toList();
      await _prefs.setString(_communitiesKey, json.encode(communitiesJson));
      await cacheLastSyncTime('communities', DateTime.now());
    } catch (e) {
      // Log error but don't throw - caching is not critical
    }
  }

  @override
  Future<List<CommunityModel>?> getCachedCommunities() async {
    try {
      final cachedData = _prefs.getString(_communitiesKey);
      if (cachedData != null) {
        final List<dynamic> communitiesJson = json.decode(cachedData);
        return communitiesJson
            .map((json) => CommunityModel.fromJson(json))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheFriends(List<FriendModel> friends) async {
    try {
      final friendsJson = friends.map((f) => f.toJson()).toList();
      await _prefs.setString(_friendsKey, json.encode(friendsJson));
      await cacheLastSyncTime('friends', DateTime.now());
    } catch (e) {
      // Log error but don't throw
    }
  }

  @override
  Future<List<FriendModel>?> getCachedFriends() async {
    try {
      final cachedData = _prefs.getString(_friendsKey);
      if (cachedData != null) {
        final List<dynamic> friendsJson = json.decode(cachedData);
        return friendsJson.map((json) => FriendModel.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheMessages(
    String chatId,
    List<ChatMessageModel> messages,
  ) async {
    try {
      final messagesJson = messages.map((m) => m.toJson()).toList();
      await _prefs.setString(
        '$_messagesKeyPrefix$chatId',
        json.encode(messagesJson),
      );
      await cacheLastSyncTime('messages_$chatId', DateTime.now());
    } catch (e) {
      // Log error but don't throw
    }
  }

  @override
  Future<List<ChatMessageModel>?> getCachedMessages(String chatId) async {
    try {
      final cachedData = _prefs.getString('$_messagesKeyPrefix$chatId');
      if (cachedData != null) {
        final List<dynamic> messagesJson = json.decode(cachedData);
        return messagesJson
            .map((json) => ChatMessageModel.fromJson(json))
            .toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final keys = _prefs.getKeys();
      final chatKeys = keys.where(
        (key) =>
            key.startsWith(_communitiesKey) ||
            key.startsWith(_friendsKey) ||
            key.startsWith(_messagesKeyPrefix) ||
            key.startsWith(_syncTimePrefix),
      );

      for (final key in chatKeys) {
        await _prefs.remove(key);
      }
    } catch (e) {
      // Log error but don't throw
    }
  }

  @override
  Future<void> cacheLastSyncTime(String key, DateTime timestamp) async {
    try {
      await _prefs.setString(
        '$_syncTimePrefix$key',
        timestamp.toIso8601String(),
      );
    } catch (e) {
      // Log error but don't throw
    }
  }

  @override
  Future<DateTime?> getLastSyncTime(String key) async {
    try {
      final timeString = _prefs.getString('$_syncTimePrefix$key');
      if (timeString != null) {
        return DateTime.parse(timeString);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
