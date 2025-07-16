import 'dart:convert';
import 'dart:io';

import 'package:livera/core/services/cloudinary_service.dart';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/community_model.dart';
import '../models/member_model.dart';

abstract class CommunityRemoteDataSource {
  /// Create a new community
  Future<CommunityModel> createCommunity({
    required String name,
    String? description,
    String? profileImage,
  });

  /// Get community details
  Future<CommunityModel> getCommunityDetails(String communityId);

  /// Update community
  Future<CommunityModel> updateCommunity({
    required String communityId,
    String? name,
    String? description,
    String? profileImage,
  });

  /// Delete community
  Future<void> deleteCommunity(String communityId);

  /// Join community
  Future<void> joinCommunity(String communityId);

  /// Leave community
  Future<void> leaveCommunity(String communityId);

  /// Upload profile image
  Future<String> uploadProfileImage(String imagePath);

  /// Get community members
  Future<List<MemberModel>> getCommunityMembers(String communityId);

  /// Add member to community
  Future<void> addMemberToCommunity({
    required String communityId,
    required String memberId,
  });

  /// Remove member from community
  Future<void> removeMemberFromCommunity({
    required String communityId,
    required String memberId,
  });
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final ApiClient apiClient;

  CommunityRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CommunityModel> createCommunity({
    required String name,
    String? description,
    String? profileImage,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'groupName': name,
        if (description != null) 'description': description,
        if (profileImage != null) 'groupProfileImage': profileImage,
      };

      final response = await apiClient.post(
        ChatApiConstants.createCommunity,
        body: body,
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (jsonResponse['success'] == true) {
          // Check if community data is returned
          if (jsonResponse['data'] != null) {
            return CommunityModel.fromJson(jsonResponse['data']);
          } else if (jsonResponse['community'] != null) {
            return CommunityModel.fromJson(jsonResponse['community']);
          } else {
            // Server only returned success status, create a minimal community model
            return CommunityModel(
              id: jsonResponse['communityId'] ?? '', // Some servers return ID
              name: name,
              description: description,
              profileImage: profileImage,
              shareLink: null,
              members: const [],
              isCreator: true,
              isUserInGroup: true,
              isUserRequested: false,
              isUserAccepted: true,
              isBot: false,
              role: 'admin',
              userWallpaper: null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        } else {
          throw ServerException(
            jsonResponse['message'] ?? 'Failed to create community',
          );
        }
      } else {
        throw ServerException(
          jsonResponse['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create community: ${e.toString()}');
    }
  }

  @override
  Future<CommunityModel> getCommunityDetails(String communityId) async {
    try {
      final response = await apiClient.get(
        '${ChatApiConstants.accessChatUrl}$communityId',
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final communityData = jsonResponse['data']['groupDetails'];
          return CommunityModel.fromJson(communityData);
        } else {
          throw ServerException(
            jsonResponse['message'] ?? 'Failed to get community details',
          );
        }
      } else {
        throw ServerException(
          jsonResponse['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get community details: ${e.toString()}');
    }
  }

  @override
  Future<CommunityModel> updateCommunity({
    required String communityId,
    String? name,
    String? description,
    String? profileImage,
  }) async {
    try {
      final Map<String, dynamic> body = {};

      if (name != null) body['groupName'] = name;
      if (description != null) body['description'] = description;
      if (profileImage != null) body['groupProfileImage'] = profileImage;

      final response = await apiClient.post(
        '${ChatApiConstants.editCommunity}$communityId',
        body: body,
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (jsonResponse['success'] == true) {
          // Return updated community details
          return await getCommunityDetails(communityId);
        } else {
          throw ServerException(
            jsonResponse['message'] ?? 'Failed to update community',
          );
        }
      } else {
        throw ServerException(
          jsonResponse['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update community: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCommunity(String communityId) async {
    try {
      final response = await apiClient.post(
        '${ChatApiConstants.deleteCommunity}$communityId',
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerException(
          jsonResponse['message'] ?? 'Failed to delete community',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to delete community: ${e.toString()}');
    }
  }

  @override
  Future<void> joinCommunity(String communityId) async {
    try {
      final response = await apiClient.post(
        '${ChatApiConstants.joinCommunity}$communityId',
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerException(
          jsonResponse['message'] ?? 'Failed to join community',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to join community: ${e.toString()}');
    }
  }

  @override
  Future<void> leaveCommunity(String communityId) async {
    try {
      final response = await apiClient.post(
        '${ChatApiConstants.leftCommunity}$communityId',
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerException(
          jsonResponse['message'] ?? 'Failed to leave community',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to leave community: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfileImage(String imagePath) async {
    try {
      String? url = await CloudinaryService.uploadSingleImage(
        file: File(imagePath),
      );
      return url ?? '';
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to upload image: ${e.toString()}');
    }
  }

  @override
  Future<List<MemberModel>> getCommunityMembers(String communityId) async {
    try {
      final response = await apiClient.get(
        '${ChatApiConstants.getCommunityMembers}$communityId',
      );
      final jsonResponse = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final membersData = jsonResponse['data'] as List;
          return membersData
              .map((member) => MemberModel.fromJson(member))
              .toList();
        } else {
          throw ServerException(
            jsonResponse['message'] ?? 'Failed to get community members',
          );
        }
      } else {
        throw ServerException(
          jsonResponse['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get community members: ${e.toString()}');
    }
  }

  @override
  Future<void> addMemberToCommunity({
    required String communityId,
    required String memberId,
  }) async {
    try {
      final response = await apiClient.post(
        '${ChatApiConstants.addFriendToCommunity}$communityId',
        body: {'memberId': memberId},
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerException(
          jsonResponse['message'] ?? 'Failed to add member to community',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        'Failed to add member to community: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> removeMemberFromCommunity({
    required String communityId,
    required String memberId,
  }) async {
    try {
      final response = await apiClient.post(
        '${ChatApiConstants.removeFromCommunity}$communityId',
        body: {'memberId': memberId},
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ServerException(
          jsonResponse['message'] ?? 'Failed to remove member from community',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        'Failed to remove member from community: ${e.toString()}',
      );
    }
  }
}
