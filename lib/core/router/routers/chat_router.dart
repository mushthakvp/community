import 'package:go_router/go_router.dart';

import '../../../features/chat_module/vchat/presentation/pages/chat_home_page.dart';
import '../../../features/chat_module/vchat/presentation/pages/community_chat_page.dart';
import '../../../features/chat_module/vchat/presentation/pages/single_chat_page.dart';

class ChatRouter {
  static List<RouteBase> get routes => [
    GoRoute(
      path: '/chat-home',
      builder: (context, state) => const ChatHomePage(),
    ),
    GoRoute(
      path: '/single-chat',
      builder: (context, state) {
        return SingleChatPage(chatId: '', friendId: '', friendName: '');
      },
    ),
    GoRoute(
      path: '/community-chat',
      builder: (context, state) {
        return CommunityChatPage(communityId: '', communityName: '');
      },
    ),
  ];
}
