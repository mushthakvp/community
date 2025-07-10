import 'package:go_router/go_router.dart';

import '../../../features/chat_module/vchat/presentation/pages/chat_home_page.dart';
import '../../../features/chat_module/vchat/presentation/pages/community_chat_page.dart';
import '../../../features/chat_module/vchat/presentation/pages/single_chat_page.dart';

class ChatRouter {
  static const String chatHomePath = '/chat';
  static const String singleChatPath = '/chat/single';
  static const String communityChatPath = '/chat/community';

  static List<RouteBase> get routes => [
    GoRoute(
      path: chatHomePath,
      name: 'chat-home',
      builder: (context, state) => const ChatHomePage(),
    ),
    GoRoute(
      path: '$singleChatPath/:friendId',
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
      path: '$communityChatPath/:communityId',
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

  static void navigateToChatHome(context) {
    GoRouter.of(context).pushNamed(chatHomePath);
  }

  static void navigateToSingleChat(
    context, {
    required String friendId,
    String? chatId,
    String? friendName,
    String? friendAvatar,
  }) {
    GoRouter.of(context).pushNamed(
      'single-chat',
      pathParameters: {'friendId': friendId},
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
    GoRouter.of(context).pushNamed(
      'community-chat',
      pathParameters: {'communityId': communityId},
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
