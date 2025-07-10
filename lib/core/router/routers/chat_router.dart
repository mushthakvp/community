import 'package:go_router/go_router.dart';

import '../../../features/chat_module/vchat/presentation/pages/chat_home_page.dart';
import '../../../features/chat_module/vchat/presentation/pages/community_chat_page.dart';
import '../../../features/chat_module/vchat/presentation/pages/single_chat_page.dart';
import '../../constants/route_constants.dart';

class ChatRouter {
  static List<RouteBase> get routes => [
    GoRoute(
      path: RouteConstants.chatHomePath,
      name: 'chat-home',
      builder: (context, state) => const ChatHomePage(),
    ),
    GoRoute(
      path: '${RouteConstants.singleChatPath}/:friendId',
      name: 'single-chat',
      builder: (context, state) {
        final friendId = state.pathParameters['friendId']!;
        final extra = state.extra as Map<String, dynamic>?;

        return SingleChatPage(
          chatId: extra?['chatId'] ?? '',
          friendId: friendId,
          friendName: extra?['friendName'] ?? 'Unknown User',
          friendAvatar: extra?['friendAvatar'],
        );
      },
    ),

    GoRoute(
      path: '${RouteConstants.communityChatPath}/:communityId',
      name: 'community-chat',
      builder: (context, state) {
        final communityId = state.pathParameters['communityId']!;
        final extra = state.extra as Map<String, dynamic>?;

        return CommunityChatPage(
          communityId: communityId,
          communityName: extra?['communityName'] ?? 'Unknown Community',
          communityImage: extra?['communityImage'],
        );
      },
    ),
  ];

  // Fixed navigation methods
  static void navigateToChatHome(context) {
    GoRouter.of(context).push(RouteConstants.chatHomePath);
  }

  static void goToChatHome(context) {
    GoRouter.of(context).go(RouteConstants.chatHomePath);
  }

  static void navigateToSingleChat(
    context, {
    required String friendId,
    String? chatId,
    String? friendName,
    String? friendAvatar,
  }) {
    GoRouter.of(context).push(
      '${RouteConstants.singleChatPath}/$friendId',
      extra: {
        'chatId': chatId,
        'friendName': friendName,
        'friendAvatar': friendAvatar,
      },
    );
  }

  static void navigateToCommunityChat(
    context, {
    required String communityId,
    String? communityName,
    String? communityImage,
  }) {
    GoRouter.of(context).push(
      '${RouteConstants.communityChatPath}/$communityId',
      extra: {'communityName': communityName, 'communityImage': communityImage},
    );
  }

  static void openFriendChat(
    context, {
    required String friendId,
    required String friendName,
    String? friendAvatar,
  }) {
    navigateToSingleChat(
      context,
      friendId: friendId,
      friendName: friendName,
      friendAvatar: friendAvatar,
    );
  }

  static void openCommunityChat(
    context, {
    required String communityId,
    required String communityName,
    String? communityImage,
  }) {
    navigateToCommunityChat(
      context,
      communityId: communityId,
      communityName: communityName,
      communityImage: communityImage,
    );
  }
}
