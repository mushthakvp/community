import 'dart:developer' as dev;

import 'package:dartz/dartz.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/birthday_wish_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/community_entity.dart';
import '../../domain/entities/friend_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  final ChatLocalDataSource _localDataSource;

  ChatRepositoryImpl({
    required ChatRemoteDataSource remoteDataSource,
    required ChatLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<CommunityEntity>>> getCommunities({
    String? status,
    String? type,
  }) async {
    try {
      // Try to get cached data first
      final cachedCommunities = await _localDataSource.getCachedCommunities();
      final lastSyncTime = await _localDataSource.getLastSyncTime(
        'communities',
      );

      // Check if cache is still valid (within 5 minutes)
      if (cachedCommunities != null &&
          lastSyncTime != null &&
          DateTime.now().difference(lastSyncTime).inMinutes < 5) {
        final entities = cachedCommunities
            .map((model) => model.toEntity())
            .toList();
        return Right(entities);
      }

      // Fetch fresh data from remote
      final response = await _remoteDataSource.getCommunities(
        status: status,
        type: type,
      );

      if (response.success == true && response.data?.data != null) {
        final communities = response.data!.data!;

        // Cache the fresh data
        await _localDataSource.cacheCommunities(communities);

        final entities = communities.map((model) => model.toEntity()).toList();
        return Right(entities);
      } else {
        return Left(
          ServerFailure(
            message: response.message ?? 'Failed to load communities',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getCommunities: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getCommunities: ${e.message}');

      // Try to return cached data on network error
      final cachedCommunities = await _localDataSource.getCachedCommunities();
      if (cachedCommunities != null) {
        final entities = cachedCommunities
            .map((model) => model.toEntity())
            .toList();
        return Right(entities);
      }

      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getCommunities',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CommunityEntity>> createCommunity({
    required String name,
    String? description,
    String? profileImage,
  }) async {
    try {
      final community = await _remoteDataSource.createCommunity(
        name: name,
        description: description,
        profileImage: profileImage,
      );

      return Right(community.toEntity());
    } on ServerException catch (e) {
      dev.log('Server exception in createCommunity: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in createCommunity: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in createCommunity',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CommunityEntity>> getCommunityDetails(
    String communityId,
  ) async {
    try {
      final community = await _remoteDataSource.getCommunityDetails(
        communityId,
      );
      return Right(community.toEntity());
    } on ServerException catch (e) {
      dev.log('Server exception in getCommunityDetails: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getCommunityDetails: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getCommunityDetails',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> joinCommunity(String communityId) async {
    try {
      final result = await _remoteDataSource.joinCommunity(communityId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in joinCommunity: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in joinCommunity: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in joinCommunity',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> leaveCommunity(String communityId) async {
    try {
      final result = await _remoteDataSource.leaveCommunity(communityId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in leaveCommunity: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in leaveCommunity: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in leaveCommunity',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCommunity(String communityId) async {
    try {
      final result = await _remoteDataSource.deleteCommunity(communityId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in deleteCommunity: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in deleteCommunity: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in deleteCommunity',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CommunityEntity>> editCommunity({
    required String communityId,
    String? name,
    String? description,
    String? profileImage,
  }) async {
    try {
      final community = await _remoteDataSource.editCommunity(
        communityId: communityId,
        name: name,
        description: description,
        profileImage: profileImage,
      );

      return Right(community.toEntity());
    } on ServerException catch (e) {
      dev.log('Server exception in editCommunity: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in editCommunity: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in editCommunity',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FriendEntity>>> getFriends({
    required String type,
  }) async {
    try {
      // Try cached data first
      final cachedFriends = await _localDataSource.getCachedFriends();
      final lastSyncTime = await _localDataSource.getLastSyncTime('friends');

      if (cachedFriends != null &&
          lastSyncTime != null &&
          DateTime.now().difference(lastSyncTime).inMinutes < 5) {
        final entities = cachedFriends
            .map((model) => model.toEntity())
            .toList();
        return Right(entities);
      }

      final response = await _remoteDataSource.getFriends(type: type);

      if (response.success == true && response.data?.data != null) {
        final friends = response.data!.data!;

        // Cache the fresh data
        await _localDataSource.cacheFriends(friends);

        final entities = friends.map((model) => model.toEntity()).toList();
        return Right(entities);
      } else {
        return Left(
          ServerFailure(message: response.message ?? 'Failed to load friends'),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getFriends: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getFriends: ${e.message}');

      // Try to return cached data on network error
      final cachedFriends = await _localDataSource.getCachedFriends();
      if (cachedFriends != null) {
        final entities = cachedFriends
            .map((model) => model.toEntity())
            .toList();
        return Right(entities);
      }

      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getFriends',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendFriendRequest(String userId) async {
    try {
      final result = await _remoteDataSource.sendFriendRequest(userId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in sendFriendRequest: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in sendFriendRequest: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in sendFriendRequest',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> acceptFriendRequest(String userId) async {
    try {
      final result = await _remoteDataSource.acceptFriendRequest(userId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in acceptFriendRequest: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in acceptFriendRequest: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in acceptFriendRequest',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectFriendRequest(String userId) async {
    try {
      final result = await _remoteDataSource.rejectFriendRequest(userId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in rejectFriendRequest: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in rejectFriendRequest: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in rejectFriendRequest',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeFriend(String userId) async {
    try {
      final result = await _remoteDataSource.removeFriend(userId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in removeFriend: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in removeFriend: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in removeFriend',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages({
    required String chatId,
    int? limit,
    String? lastMessageId,
  }) async {
    try {
      // Try cached messages first
      final cachedMessages = await _localDataSource.getCachedMessages(chatId);
      final lastSyncTime = await _localDataSource.getLastSyncTime(
        'messages_$chatId',
      );

      if (cachedMessages != null &&
          lastSyncTime != null &&
          DateTime.now().difference(lastSyncTime).inMinutes < 2) {
        final entities = cachedMessages
            .map((model) => model.toEntity())
            .toList();
        return Right(entities);
      }

      final response = await _remoteDataSource.getMessages(
        chatId: chatId,
        limit: limit,
        lastMessageId: lastMessageId,
      );

      if (response.success == true && response.data != null) {
        final messages = response.data!;

        // Cache the fresh data
        await _localDataSource.cacheMessages(chatId, messages);

        final entities = messages.map((model) => model.toEntity()).toList();
        return Right(entities);
      } else {
        return Left(
          ServerFailure(message: response.message ?? 'Failed to load messages'),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getMessages: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getMessages: ${e.message}');

      // Try to return cached data on network error
      final cachedMessages = await _localDataSource.getCachedMessages(chatId);
      if (cachedMessages != null) {
        final entities = cachedMessages
            .map((model) => model.toEntity())
            .toList();
        return Right(entities);
      }

      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getMessages',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final message = await _remoteDataSource.sendMessage(
        receiverId: receiverId,
        content: content,
        type: type.name,
        replyToId: replyToId,
        metadata: metadata,
      );

      return Right(message.toEntity());
    } on ServerException catch (e) {
      dev.log('Server exception in sendMessage: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in sendMessage: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in sendMessage',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markMessageAsRead(String messageId) async {
    try {
      // Implementation would depend on your API structure
      // For now, returning success
      return const Right(true);
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in markMessageAsRead',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(String messageId) async {
    try {
      // Implementation would depend on your API structure
      // For now, returning success
      return const Right(true);
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in deleteMessage',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> accessChat(String friendId) async {
    try {
      final chatId = await _remoteDataSource.accessChat(friendId);
      return Right(chatId);
    } on ServerException catch (e) {
      dev.log('Server exception in accessChat: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in accessChat: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in accessChat',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllChats() async {
    try {
      final chats = await _remoteDataSource.getAllChats();
      return Right(chats);
    } on ServerException catch (e) {
      dev.log('Server exception in getAllChats: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getAllChats: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getAllChats',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BirthdayWishEntity>>>
  getTodaysBirthdayFriends() async {
    try {
      final response = await _remoteDataSource.getTodaysBirthdayFriends();

      if (response.success == true && response.data != null) {
        final birthdayFriends = response.data!;
        final entities = birthdayFriends
            .map((model) => model.toEntity())
            .toList();
        return Right(entities);
      } else {
        return Left(
          ServerFailure(
            message: response.message ?? 'Failed to load birthday friends',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getTodaysBirthdayFriends: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getTodaysBirthdayFriends: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getTodaysBirthdayFriends',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendBirthdayWish({
    required String friendId,
    required String message,
  }) async {
    try {
      final result = await _remoteDataSource.sendBirthdayWish(
        friendId: friendId,
        message: message,
      );
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in sendBirthdayWish: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in sendBirthdayWish: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in sendBirthdayWish',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getWallpapers() async {
    try {
      final wallpapers = await _remoteDataSource.getWallpapers();
      return Right(wallpapers);
    } on ServerException catch (e) {
      dev.log('Server exception in getWallpapers: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getWallpapers: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getWallpapers',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> setSingleChatWallpaper({
    required String chatId,
    required String wallpaperUrl,
  }) async {
    try {
      final result = await _remoteDataSource.setSingleChatWallpaper(
        chatId: chatId,
        wallpaperUrl: wallpaperUrl,
      );
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in setSingleChatWallpaper: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in setSingleChatWallpaper: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in setSingleChatWallpaper',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> setGroupWallpaper({
    required String groupId,
    required String wallpaperUrl,
  }) async {
    try {
      final result = await _remoteDataSource.setGroupWallpaper(
        groupId: groupId,
        wallpaperUrl: wallpaperUrl,
      );
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in setGroupWallpaper: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in setGroupWallpaper: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in setGroupWallpaper',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // Community Member Operations - Implementing missing methods
  @override
  Future<Either<Failure, List<FriendEntity>>> getCommunityMembers(
    String communityId,
  ) async {
    try {
      // This would use a specific endpoint for community members
      // Using getFriends as placeholder - you'll need to update with correct endpoint
      final response = await _remoteDataSource.getFriends(
        type: 'community_members',
      );

      if (response.success == true && response.data?.data != null) {
        final members = response.data!.data!;
        final entities = members.map((model) => model.toEntity()).toList();
        return Right(entities);
      } else {
        return Left(
          ServerFailure(
            message: response.message ?? 'Failed to load community members',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getCommunityMembers: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getCommunityMembers: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getCommunityMembers',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FriendEntity>>> getCommunityMemberRequests(
    String communityId,
  ) async {
    try {
      // This would use a specific endpoint for member requests
      final response = await _remoteDataSource.getFriends(
        type: 'member_requests',
      );

      if (response.success == true && response.data?.data != null) {
        final requests = response.data!.data!;
        final entities = requests.map((model) => model.toEntity()).toList();
        return Right(entities);
      } else {
        return Left(
          ServerFailure(
            message: response.message ?? 'Failed to load member requests',
          ),
        );
      }
    } on ServerException catch (e) {
      dev.log('Server exception in getCommunityMemberRequests: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in getCommunityMemberRequests: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in getCommunityMemberRequests',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> approveMemberRequest({
    required String communityId,
    required String userId,
  }) async {
    try {
      // Implementation would call specific API endpoint
      final result = await _remoteDataSource.acceptFriendRequest(userId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in approveMemberRequest: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in approveMemberRequest: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in approveMemberRequest',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectMemberRequest({
    required String communityId,
    required String userId,
  }) async {
    try {
      // Implementation would call specific API endpoint
      final result = await _remoteDataSource.rejectFriendRequest(userId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in rejectMemberRequest: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in rejectMemberRequest: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in rejectMemberRequest',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> addMemberToCommunity({
    required String communityId,
    required String userId,
  }) async {
    try {
      // Implementation would call specific API endpoint
      final result = await _remoteDataSource.sendFriendRequest(userId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in addMemberToCommunity: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in addMemberToCommunity: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in addMemberToCommunity',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeMemberFromCommunity({
    required String communityId,
    required String userId,
  }) async {
    try {
      // Implementation would call specific API endpoint
      final result = await _remoteDataSource.removeFriend(userId);
      return Right(result);
    } on ServerException catch (e) {
      dev.log('Server exception in removeMemberFromCommunity: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      dev.log('Network exception in removeMemberFromCommunity: ${e.message}');
      return Left(NetworkFailure(message: e.message));
    } catch (e, stackTrace) {
      dev.log(
        'Unexpected error in removeMemberFromCommunity',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
