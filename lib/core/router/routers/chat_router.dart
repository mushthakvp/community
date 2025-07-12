import 'package:go_router/go_router.dart';

import '../../../features/chat_module/chat_screen/presentation/pages/chat_page.dart';
import '../../../features/chat_module/vchat/presentation/pages/vchat_home_page.dart';

class ChatRouter {
  /// Route paths constants
  static const String vchatHomePath = '/chat';
  static const String chatScreenPath = '/chat';
  static const String personalChatPath = '/personal-chat';
  static const String createCommunityPath = '/create-community';

  /// Chat module related routes
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
  ];
}
