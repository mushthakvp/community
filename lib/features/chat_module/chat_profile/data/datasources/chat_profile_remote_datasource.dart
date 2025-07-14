import 'dart:convert';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/community_info_model.dart';
import '../models/community_member_model.dart';
import '../models/friend_model.dart';
import '../models/member_request_model.dart';

abstract class ChatProfileRemoteDataSource {
  Future<List<CommunityMemberModel>> getCommunityMembers(String communityId);
  Future<void> removeMember(String communityId, String userId);
  Future<void> addMembers(String communityId, List<String> memberIds);
  Future<MemberRequestsModel> getMemberRequests(String communityId);
  Future<void> approveRequest(String communityId, String requestId);
  Future<void> rejectRequest(String communityId, String requestId);
  Future<List<FriendModel>> getFriends();
  Future<void> sendFriendRequest(String userId);
  Future<CommunityInfoModel> getCommunityInfo(String communityId);
  Future<void> leaveCommunity(String communityId);
}

class ChatProfileRemoteDataSourceImpl implements ChatProfileRemoteDataSource {
  final ApiClient apiClient;

  ChatProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CommunityMemberModel>> getCommunityMembers(
    String communityId,
  ) async {
    try {
      final response = await apiClient.get(
        '${ChatApiConstants.getCommunityMembers}$communityId',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final responseModel = CommunityMembersResponseModel.fromJson(data);
        return responseModel.members;
      } else {
        throw ServerException('Failed to load community members');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addMembers(String communityId, List<String> memberIds) async {
    try {
      final response = await apiClient.post(
        '${ChatApiConstants.addFriendToCommunity}$communityId',
        body: {'memberIds': memberIds},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final data = jsonDecode(response.body);
        throw ServerException(data['message'] ?? 'Failed to add members');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MemberRequestsModel> getMemberRequests(String communityId) async {
    try {
      final response = await apiClient.get(
        '${ChatApiConstants.getCommunityMemberRequest}$communityId',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final responseModel = MemberRequestResponseModel.fromJson(data);
        return responseModel.requests ??
            const MemberRequestsModel(id: '', creator: '', requests: []);
      } else {
        throw ServerException('Failed to load member requests');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> approveRequest(String communityId, String requestId) async {
    try {
      final response = await apiClient.post(
        ChatApiConstants.approveMemberRequest,
        body: {'groupId': communityId, 'requestId': requestId},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final data = jsonDecode(response.body);
        throw ServerException(data['message'] ?? 'Failed to approve request');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> rejectRequest(String communityId, String requestId) async {
    try {
      final response = await apiClient.post(
        ChatApiConstants.rejectMemberRequest,
        body: {'groupId': communityId, 'requestId': requestId},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final data = jsonDecode(response.body);
        throw ServerException(data['message'] ?? 'Failed to reject request');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<FriendModel>> getFriends() async {
    try {
      final response = await apiClient.get(
        '${ChatApiConstants.getMyGroupData}friends',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final responseModel = FriendsResponseModel.fromJson(data);
        return responseModel.data;
      } else {
        throw ServerException('Failed to load friends');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendFriendRequest(String userId) async {
    try {
      final response = await apiClient.post(
        '${ChatApiConstants.sendFriendRequest}$userId',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final data = jsonDecode(response.body);
        throw ServerException(
          data['message'] ?? 'Failed to send friend request',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommunityInfoModel> getCommunityInfo(String communityId) async {
    try {
      final response = await apiClient.get(
        '${ChatApiConstants.enterChat}$communityId',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        final groupDetails =
            data['data']?['groupDetails'] ?? data['groupDetails'];
        if (groupDetails != null) {
          return CommunityInfoModel.fromJson(groupDetails);
        } else {
          throw ServerException('Community info not found');
        }
      } else {
        throw ServerException('Failed to load community info');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> leaveCommunity(String communityId) async {
    try {
      final response = await apiClient.post(
        '${ChatApiConstants.leftCommunity}$communityId',
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final data = jsonDecode(response.body);
        throw ServerException(data['message'] ?? 'Failed to leave community');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> removeMember(String communityId, String userId) {
    throw UnimplementedError();
  }
}
