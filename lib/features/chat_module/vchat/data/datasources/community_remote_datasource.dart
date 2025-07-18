import 'dart:convert';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../models/community_model.dart';
import '../models/friend_model.dart';

abstract class CommunityRemoteDataSource {
  Future<List<CommunityModel>> getRecommendedCommunities(String type);
  Future<List<dynamic>> getMyGroups(String type);
  Future<void> joinCommunity(String communityId);
  Future<void> leaveCommunity(String communityId);
  Future<CommunityModel> createCommunity({
    required String name,
    required String description,
    String? image,
  });
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final ApiClient apiClient;

  CommunityRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CommunityModel>> getRecommendedCommunities(String type) async {
    final response = await apiClient.get(
      '${ChatApiConstants.getRecommendCommunity}?status=$type',
    );

    final data = jsonDecode(response.body);
    final communitiesJson = data['data'] as List<dynamic>;
    return communitiesJson
        .map((json) => CommunityModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<dynamic>> getMyGroups(String type) async {
    final response = await apiClient.get(
      '${ChatApiConstants.getMyGroupData}?type=$type',
    );
    final data = jsonDecode(response.body);
    final groupsJson = data['data'] as List<dynamic>;
    return groupsJson.map((json) {
      try {
        if (type == 'friends' || type == 'request') {
          if (json.containsKey('isOnline') ||
              json.containsKey('lastSeen') ||
              json.containsKey('friendName') ||
              json.containsKey('userName') ||
              json.containsKey('email') ||
              json.containsKey('phone') ||
              (!json.containsKey('memberCount') &&
                  !json.containsKey('groupName'))) {
            return FriendModel.fromJson(json);
          }
        }
        if (json.containsKey('memberCount') ||
            json.containsKey('groupName') ||
            json.containsKey('groupProfileImage')) {
          return CommunityModel.fromJson(json);
        }
        if (type == 'friends' || type == 'request') {
          return FriendModel(
            id: json['_id'] ?? json['id'] ?? '',
            name:
                json['name'] ??
                json['userName'] ??
                json['friendName'] ??
                'Unknown',
            profileImage:
                json['profileImage'] ?? json['avatar'] ?? json['image'],
            isOnline: json['isOnline'] ?? false,
            lastSeen: json['lastSeen'] != null
                ? DateTime.tryParse(json['lastSeen'])
                : null,
            status: json['status'],
            email: json['email'],
            phone: json['phone'],
          );
        } else {
          return CommunityModel.fromJson(json);
        }
      } catch (e) {
        if (type == 'friends' || type == 'request') {
          return FriendModel(
            id: json['_id'] ?? json['id'] ?? '',
            name:
                json['name'] ??
                json['groupName'] ??
                json['userName'] ??
                'Unknown',
            profileImage:
                json['profileImage'] ??
                json['groupProfileImage'] ??
                json['avatar'],
            isOnline: false,
          );
        } else {
          return CommunityModel(
            id: json['_id'] ?? json['id'] ?? '',
            name: json['groupName'] ?? json['name'] ?? 'Unknown',
            image: json['groupProfileImage'] ?? json['profileImage'],
            memberCount: json['memberCount'] ?? 0,
          );
        }
      }
    }).toList();
  }

  @override
  Future<void> joinCommunity(String communityId) async {
    await apiClient.post('${ChatApiConstants.joinCommunity}$communityId');
  }

  @override
  Future<void> leaveCommunity(String communityId) async {
    await apiClient.post('${ChatApiConstants.leftCommunity}$communityId');
  }

  @override
  Future<CommunityModel> createCommunity({
    required String name,
    required String description,
    String? image,
  }) async {
    final response = await apiClient.post(
      ChatApiConstants.createCommunity,
      body: {
        'groupName': name,
        'description': description,
        if (image != null) 'groupProfileImage': image,
      },
    );

    final data = jsonDecode(response.body);
    return CommunityModel.fromJson(data['community']);
  }
}
