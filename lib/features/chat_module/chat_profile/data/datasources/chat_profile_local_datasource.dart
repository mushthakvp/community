import 'dart:convert';

import '../../../../../core/services/storage_service.dart';
import '../models/community_member_model.dart';
import '../models/friend_model.dart';

abstract class ChatProfileLocalDataSource {
  Future<List<CommunityMemberModel>?> getCachedMembers(String communityId);
  Future<void> cacheMembers(
    String communityId,
    List<CommunityMemberModel> members,
  );
  Future<List<FriendModel>?> getCachedFriends();
  Future<void> cacheFriends(List<FriendModel> friends);
  Future<void> clearCache();
}

class ChatProfileLocalDataSourceImpl implements ChatProfileLocalDataSource {
  static const String _membersPrefix = 'community_members_';
  static const String _friendsKey = 'cached_friends';
  static const Duration _cacheExpiry = Duration(minutes: 30);

  @override
  Future<List<CommunityMemberModel>?> getCachedMembers(
    String communityId,
  ) async {
    try {
      final cacheKey = '$_membersPrefix$communityId';
      final cacheData = StorageService.getString(cacheKey);

      if (cacheData != null) {
        final data = jsonDecode(cacheData);
        final timestamp = DateTime.parse(data['timestamp']);

        if (DateTime.now().difference(timestamp) < _cacheExpiry) {
          final membersJson = data['members'] as List;
          return membersJson
              .map((json) => CommunityMemberModel.fromJson(json))
              .toList();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheMembers(
    String communityId,
    List<CommunityMemberModel> members,
  ) async {
    try {
      final cacheKey = '$_membersPrefix$communityId';
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'members': members.map((member) => member.toJson()).toList(),
      };
      await StorageService.setString(cacheKey, jsonEncode(cacheData));
    } catch (e) {
      // Cache failure is not critical
    }
  }

  @override
  Future<List<FriendModel>?> getCachedFriends() async {
    try {
      final cacheData = StorageService.getString(_friendsKey);

      if (cacheData != null) {
        final data = jsonDecode(cacheData);
        final timestamp = DateTime.parse(data['timestamp']);

        if (DateTime.now().difference(timestamp) < _cacheExpiry) {
          final friendsJson = data['friends'] as List;
          return friendsJson.map((json) => FriendModel.fromJson(json)).toList();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheFriends(List<FriendModel> friends) async {
    try {
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'friends': friends.map((friend) => friend.toJson()).toList(),
      };
      await StorageService.setString(_friendsKey, jsonEncode(cacheData));
    } catch (e) {
      // Cache failure is not critical
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await StorageService.remove(_friendsKey);
    } catch (e) {
      // Cache clear failure is not critical
    }
  }
}
