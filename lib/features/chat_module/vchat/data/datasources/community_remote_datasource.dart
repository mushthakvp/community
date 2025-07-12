import 'dart:convert';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/network/api_client.dart';
import '../models/community_model.dart';

abstract class CommunityRemoteDataSource {
  Future<List<CommunityModel>> getRecommendedCommunities(String type);
  Future<List<CommunityModel>> getMyGroups(String type);
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
  Future<List<CommunityModel>> getMyGroups(String type) async {
    final response = await apiClient.get(
      '${ChatApiConstants.getMyGroupData}?type=$type',
    );

    final data = jsonDecode(response.body);
    final groupsJson = data['data'] as List<dynamic>;
    return groupsJson.map((json) => CommunityModel.fromJson(json)).toList();
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
