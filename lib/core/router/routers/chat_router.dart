import 'package:go_router/go_router.dart';

import '../../../features/chat_module/chat_profile/presentation/pages/add_member_page.dart';
import '../../../features/chat_module/chat_profile/presentation/pages/chat_profile_page.dart';
import '../../../features/chat_module/chat_profile/presentation/pages/members_list_page.dart';
import '../../../features/chat_module/chat_screen/presentation/pages/chat_page.dart';
import '../../../features/chat_module/vchat/presentation/pages/vchat_home_page.dart';

class ChatRouter {
  /// Route paths constants
  static const String vchatHomePath = '/chat';
  static const String chatScreenPath = '/chat';
  static const String personalChatPath = '/personal-chat';
  static const String createCommunityPath = '/create-community';

  // Chat Profile Route Paths
  static const String chatProfilePath = '/chat-profile';
  static const String addMemberPath = '/add-member';
  static const String membersListPath = '/members-list';

  /// Enhanced Chat module related routes with profile management
  static List<RouteBase> get routes => [
    // ==================== VCHAT HOME ROUTE ====================
    GoRoute(
      path: vchatHomePath,
      name: 'vchatHome',
      builder: (context, state) => const VChatHomePage(),
    ),

    // ==================== CHAT SCREEN ROUTE ====================
    GoRoute(
      path: '$chatScreenPath/:chatId',
      name: 'chatScreen',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        final queryParams = state.uri.queryParameters;
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final chatName = queryParams['chatName'] ?? extra['chatName'] ?? 'Chat';
        final chatImage = queryParams['chatImage'] ?? extra['chatImage'];
        final isGroup =
            queryParams['isGroup'] == 'true' || extra['isGroup'] == true;

        return ChatPage(
          chatId: chatId,
          chatName: chatName,
          chatImage: chatImage,
          isGroup: isGroup,
        );
      },
    ),

    // ==================== CHAT PROFILE ROUTES ====================

    // Chat Profile Main Route
    GoRoute(
      path: '$chatProfilePath/:chatId',
      name: 'chatProfile',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        final queryParams = state.uri.queryParameters;
        final extra = state.extra as Map<String, dynamic>? ?? {};

        final chatName = queryParams['chatName'] ?? extra['chatName'];
        final chatImage = queryParams['chatImage'] ?? extra['chatImage'];
        final isGroup =
            queryParams['isGroup'] == 'true' || extra['isGroup'] == true;

        return ChatProfilePage(
          chatId: chatId,
          chatName: chatName,
          chatImage: chatImage,
          isGroup: isGroup,
        );
      },
    ),

    // Add Member Route
    GoRoute(
      path: '$addMemberPath/:communityId',
      name: 'addMember',
      builder: (context, state) {
        final communityId = state.pathParameters['communityId']!;
        final queryParams = state.uri.queryParameters;
        final extra = state.extra as Map<String, dynamic>? ?? {};

        final communityName =
            queryParams['communityName'] ??
            extra['communityName'] ??
            'Community';

        return AddMemberPage(
          communityId: communityId,
          communityName: communityName,
        );
      },
    ),

    // Members List Route
    GoRoute(
      path: '$membersListPath/:communityId',
      name: 'membersList',
      builder: (context, state) {
        final communityId = state.pathParameters['communityId']!;
        final queryParams = state.uri.queryParameters;
        final extra = state.extra as Map<String, dynamic>? ?? {};

        final communityName =
            queryParams['communityName'] ??
            extra['communityName'] ??
            'Community';

        return MembersListPage(
          communityId: communityId,
          communityName: communityName,
        );
      },
    ),
  ];
}
