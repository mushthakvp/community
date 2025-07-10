import 'dart:convert';
import 'dart:io';

import '../../../../../core/constants/chat_api_constants.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../models/birthday_wish_model.dart';
import '../models/chat_message_model.dart';
import '../models/community_model.dart';
import '../models/friend_model.dart';

abstract class ChatRemoteDataSource {
  // Community Operations
  Future<CommunityResponseModel> getCommunities({String? status, String? type});
  Future<CommunityModel> createCommunity({
    required String name,
    String? description,
    String? profileImage,
  });
  Future<CommunityModel> getCommunityDetails(String communityId);
  Future<bool> joinCommunity(String communityId);
  Future<bool> leaveCommunity(String communityId);
  Future<bool> deleteCommunity(String communityId);
  Future<CommunityModel> editCommunity({
    required String communityId,
    String? name,
    String? description,
    String? profileImage,
  });

  // Friend Operations
  Future<FriendResponseModel> getFriends({String? type});
  Future<bool> sendFriendRequest(String userId);
  Future<bool> acceptFriendRequest(String userId);
  Future<bool> rejectFriendRequest(String userId);
  Future<bool> removeFriend(String userId);

  // Message Operations
  Future<ChatMessageResponseModel> getMessages({
    required String chatId,
    int? limit,
    String? lastMessageId,
  });
  Future<ChatMessageModel> sendMessage({
    required String receiverId,
    required String content,
    String type = 'text',
    String? replyToId,
    Map<String, dynamic>? metadata,
  });

  // Chat Operations
  Future<String> accessChat(String friendId);
  Future<List<Map<String, dynamic>>> getAllChats();

  // Birthday Wishes
  Future<BirthdayWishResponseModel> getTodaysBirthdayFriends();
  Future<bool> sendBirthdayWish({
    required String friendId,
    required String message,
  });

  // Wallpaper Operations
  Future<List<String>> getWallpapers();
  Future<bool> setSingleChatWallpaper({
    required String chatId,
    required String wallpaperUrl,
  });
  Future<bool> setGroupWallpaper({
    required String groupId,
    required String wallpaperUrl,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient _apiClient;

  ChatRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<CommunityResponseModel> getCommunities({
    String? status,
    String? type,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      if (type != null) queryParams['type'] = type;

      final response = await _apiClient.get(
        ChatApiConstants.getRecommendCommunity,
        queryParameters: queryParams,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return CommunityResponseModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to load communities');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommunityModel> createCommunity({
    required String name,
    String? description,
    String? profileImage,
  }) async {
    try {
      final body = {
        'groupName': name,
        if (description != null) 'description': description,
        if (profileImage != null) 'groupProfileImage': profileImage,
      };

      final response = await _apiClient.post(
        ChatApiConstants.createCommunity,
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return CommunityModel.fromJson(responseData['data']);
      } else {
        final errorData = json.decode(response.body);
        throw ServerException(
          errorData['message'] ?? 'Failed to create community',
        );
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommunityModel> getCommunityDetails(String communityId) async {
    try {
      final response = await _apiClient.get(
        '${ChatApiConstants.getCommunityDetails}$communityId',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return CommunityModel.fromJson(responseData['data']);
      } else {
        throw ServerException('Failed to load community details');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> joinCommunity(String communityId) async {
    try {
      final response = await _apiClient.post(
        '${ChatApiConstants.joinCommunity}$communityId',
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> leaveCommunity(String communityId) async {
    try {
      final response = await _apiClient.post(
        '${ChatApiConstants.leftCommunity}$communityId',
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> deleteCommunity(String communityId) async {
    try {
      final response = await _apiClient.delete(
        '${ChatApiConstants.deleteCommunity}$communityId',
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CommunityModel> editCommunity({
    required String communityId,
    String? name,
    String? description,
    String? profileImage,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['groupName'] = name;
      if (description != null) body['description'] = description;
      if (profileImage != null) body['groupProfileImage'] = profileImage;

      final response = await _apiClient.put(
        '${ChatApiConstants.editCommunity}$communityId',
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return CommunityModel.fromJson(responseData['data']);
      } else {
        throw ServerException('Failed to edit community');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<FriendResponseModel> getFriends({String? type}) async {
    try {
      final queryParams = <String, String>{};
      if (type != null) queryParams['type'] = type;

      final response = await _apiClient.get(
        ChatApiConstants.getMyGroupData,
        queryParameters: queryParams,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return FriendResponseModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to load friends');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> sendFriendRequest(String userId) async {
    try {
      final response = await _apiClient.post(
        '${ChatApiConstants.sendFriendRequest}$userId',
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> acceptFriendRequest(String userId) async {
    try {
      final response = await _apiClient.post(
        '${ChatApiConstants.acceptFriendRequest}$userId',
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> rejectFriendRequest(String userId) async {
    try {
      final response = await _apiClient.post(
        '${ChatApiConstants.rejectFriendRequest}$userId',
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> removeFriend(String userId) async {
    try {
      final response = await _apiClient.post(
        '${ChatApiConstants.removeFriend}$userId',
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChatMessageResponseModel> getMessages({
    required String chatId,
    int? limit,
    String? lastMessageId,
  }) async {
    try {
      final queryParams = <String, String>{
        'chatId': chatId,
        if (limit != null) 'limit': limit.toString(),
        if (lastMessageId != null) 'lastMessageId': lastMessageId,
      };

      final response = await _apiClient.get(
        ChatApiConstants.fetchAllMessagesSingleChat,
        queryParameters: queryParams,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return ChatMessageResponseModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to load messages');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String receiverId,
    required String content,
    String type = 'text',
    String? replyToId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final body = {
        'receiverId': receiverId,
        'content': content,
        'type': type,
        if (replyToId != null) 'replyToId': replyToId,
        if (metadata != null) 'metadata': metadata,
      };

      final response = await _apiClient.post(
        ChatApiConstants.sendMessage,
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return ChatMessageModel.fromJson(responseData['data']);
      } else {
        throw ServerException('Failed to send message');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> accessChat(String friendId) async {
    try {
      final response = await _apiClient.get(
        '${ChatApiConstants.accessChatUrl}$friendId',
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return responseData['data']['chatId'] as String;
      } else {
        throw ServerException('Failed to access chat');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllChats() async {
    try {
      final response = await _apiClient.get(ChatApiConstants.getAllChatLit);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(responseData['data']);
      } else {
        throw ServerException('Failed to load chats');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BirthdayWishResponseModel> getTodaysBirthdayFriends() async {
    try {
      final response = await _apiClient.get(
        ChatApiConstants.getTodaysBirthdayFriends,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return BirthdayWishResponseModel.fromJson(responseData);
      } else {
        throw ServerException('Failed to load birthday friends');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> sendBirthdayWish({
    required String friendId,
    required String message,
  }) async {
    try {
      final response = await _apiClient.post(
        ChatApiConstants.sentBirthdayWishes,
        body: {'friendId': friendId, 'message': message},
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getWallpapers() async {
    try {
      final response = await _apiClient.get(ChatApiConstants.getWallpaper);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return List<String>.from(responseData['data']);
      } else {
        throw ServerException('Failed to load wallpapers');
      }
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> setSingleChatWallpaper({
    required String chatId,
    required String wallpaperUrl,
  }) async {
    try {
      final response = await _apiClient.post(
        ChatApiConstants.setSingleChatWallpaper,
        body: {'chatId': chatId, 'wallpaperUrl': wallpaperUrl},
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> setGroupWallpaper({
    required String groupId,
    required String wallpaperUrl,
  }) async {
    try {
      final response = await _apiClient.post(
        ChatApiConstants.setGroupWallpaper,
        body: {'groupId': groupId, 'wallpaperUrl': wallpaperUrl},
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } on SocketException {
      throw const NetworkException('No internet connection');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
