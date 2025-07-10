import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/birthday_wish_entity.dart';
import '../entities/chat_message_entity.dart';
import '../entities/community_entity.dart';
import '../entities/friend_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<CommunityEntity>>> getCommunities({
    String? status,
    String? type,
  });

  Future<Either<Failure, CommunityEntity>> createCommunity({
    required String name,
    String? description,
    String? profileImage,
  });

  Future<Either<Failure, CommunityEntity>> getCommunityDetails(
    String communityId,
  );

  Future<Either<Failure, bool>> joinCommunity(String communityId);

  Future<Either<Failure, bool>> leaveCommunity(String communityId);

  Future<Either<Failure, bool>> deleteCommunity(String communityId);

  Future<Either<Failure, CommunityEntity>> editCommunity({
    required String communityId,
    String? name,
    String? description,
    String? profileImage,
  });

  // Friend Operations
  Future<Either<Failure, List<FriendEntity>>> getFriends({String? type});

  Future<Either<Failure, bool>> sendFriendRequest(String userId);

  Future<Either<Failure, bool>> acceptFriendRequest(String userId);

  Future<Either<Failure, bool>> rejectFriendRequest(String userId);

  Future<Either<Failure, bool>> removeFriend(String userId);

  // Message Operations
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages({
    required String chatId,
    int? limit,
    String? lastMessageId,
  });

  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String receiverId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
    Map<String, dynamic>? metadata,
  });

  Future<Either<Failure, bool>> markMessageAsRead(String messageId);

  Future<Either<Failure, bool>> deleteMessage(String messageId);

  // Chat Operations
  Future<Either<Failure, String>> accessChat(String friendId);

  Future<Either<Failure, List<Map<String, dynamic>>>> getAllChats();

  // Birthday Wishes
  Future<Either<Failure, List<BirthdayWishEntity>>> getTodaysBirthdayFriends();

  Future<Either<Failure, bool>> sendBirthdayWish({
    required String friendId,
    required String message,
  });

  // Wallpaper Operations
  Future<Either<Failure, List<String>>> getWallpapers();

  Future<Either<Failure, bool>> setSingleChatWallpaper({
    required String chatId,
    required String wallpaperUrl,
  });

  Future<Either<Failure, bool>> setGroupWallpaper({
    required String groupId,
    required String wallpaperUrl,
  });

  // Community Member Operations
  Future<Either<Failure, List<FriendEntity>>> getCommunityMembers(
    String communityId,
  );

  Future<Either<Failure, List<FriendEntity>>> getCommunityMemberRequests(
    String communityId,
  );

  Future<Either<Failure, bool>> approveMemberRequest({
    required String communityId,
    required String userId,
  });

  Future<Either<Failure, bool>> rejectMemberRequest({
    required String communityId,
    required String userId,
  });

  Future<Either<Failure, bool>> addMemberToCommunity({
    required String communityId,
    required String userId,
  });

  Future<Either<Failure, bool>> removeMemberFromCommunity({
    required String communityId,
    required String userId,
  });
}
