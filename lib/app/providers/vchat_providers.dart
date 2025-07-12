import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client_wrapper.dart';
import '../../features/chat_module/chat_screen/data/datasources/chat_remote_datasource.dart';
import '../../features/chat_module/chat_screen/data/datasources/socket_datasource.dart';
import '../../features/chat_module/chat_screen/data/repositories/chat_repository_impl.dart';
import '../../features/chat_module/chat_screen/domain/repositories/chat_repository.dart';
import '../../features/chat_module/chat_screen/domain/usecases/fetch_messages.dart';
import '../../features/chat_module/chat_screen/domain/usecases/send_message.dart';
import '../../features/chat_module/chat_screen/domain/usecases/upload_media.dart';
import '../../features/chat_module/chat_screen/presentation/providers/chat_provider.dart';
import '../../features/chat_module/vchat/data/datasources/community_remote_datasource.dart';
import '../../features/chat_module/vchat/data/repositories/community_repository_impl.dart';
import '../../features/chat_module/vchat/domain/repositories/community_repository.dart';
import '../../features/chat_module/vchat/domain/usecases/get_my_groups.dart';
import '../../features/chat_module/vchat/domain/usecases/get_recommended_communities.dart';
import '../../features/chat_module/vchat/domain/usecases/join_community.dart';
import '../../features/chat_module/vchat/presentation/providers/vchat_provider.dart';

/// Chat module providers for messaging and community features
class ChatProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // CHAT SCREEN DATA SOURCES
    // ========================================

    // Chat Remote Data Source (uses chat API client)
    ProxyProvider<ApiClientWrapper, ChatRemoteDataSource>(
      update: (_, wrapper, __) =>
          ChatRemoteDataSourceImpl(apiClient: wrapper.chatClient),
    ),

    // Socket Data Source
    Provider<SocketDataSource>(create: (_) => SocketDataSourceImpl()),

    // ========================================
    // CHAT SCREEN REPOSITORY
    // ========================================

    // Chat Repository
    ProxyProvider2<ChatRemoteDataSource, SocketDataSource, ChatRepository>(
      update: (_, remoteDataSource, socketDataSource, __) => ChatRepositoryImpl(
        remoteDataSource: remoteDataSource,
        socketDataSource: socketDataSource,
      ),
    ),

    // ========================================
    // CHAT SCREEN USE CASES
    // ========================================

    // Fetch Messages Use Case
    ProxyProvider<ChatRepository, FetchMessages>(
      update: (_, repository, __) => FetchMessages(repository),
    ),

    // Send Message Use Case
    ProxyProvider<ChatRepository, SendMessage>(
      update: (_, repository, __) => SendMessage(repository),
    ),

    // Upload Media Use Case
    ProxyProvider<ChatRepository, UploadMedia>(
      update: (_, repository, __) => UploadMedia(repository),
    ),

    // ========================================
    // CHAT SCREEN PROVIDER
    // ========================================

    // Chat Provider
    ChangeNotifierProxyProvider4<
      FetchMessages,
      SendMessage,
      UploadMedia,
      ChatRepository,
      ChatProvider
    >(
      create: (context) => ChatProvider(
        fetchMessages: context.read<FetchMessages>(),
        sendMessage: context.read<SendMessage>(),
        uploadMedia: context.read<UploadMedia>(),
        chatRepository: context.read<ChatRepository>(),
        fetchChatWithMessages: FetchChatWithMessages(
          context.read<ChatRepository>(),
        ),
      ),
      update:
          (
            _,
            fetchMessages,
            sendMessage,
            uploadMedia,
            chatRepository,
            previous,
          ) =>
              previous ??
              ChatProvider(
                fetchMessages: fetchMessages,
                sendMessage: sendMessage,
                uploadMedia: uploadMedia,
                chatRepository: chatRepository,
                fetchChatWithMessages: FetchChatWithMessages(chatRepository),
              ),
    ),

    // ========================================
    // VCHAT COMMUNITY DATA SOURCES
    // ========================================

    // Community Remote Data Source (uses chat API client)
    ProxyProvider<ApiClientWrapper, CommunityRemoteDataSource>(
      update: (_, wrapper, __) =>
          CommunityRemoteDataSourceImpl(apiClient: wrapper.chatClient),
    ),

    // ========================================
    // VCHAT COMMUNITY REPOSITORY
    // ========================================

    // Community Repository
    ProxyProvider<CommunityRemoteDataSource, CommunityRepository>(
      update: (_, remoteDataSource, __) =>
          CommunityRepositoryImpl(remoteDataSource: remoteDataSource),
    ),

    // ========================================
    // VCHAT COMMUNITY USE CASES
    // ========================================

    // Get Recommended Communities Use Case
    ProxyProvider<CommunityRepository, GetRecommendedCommunities>(
      update: (_, repository, __) => GetRecommendedCommunities(repository),
    ),

    // Get My Groups Use Case
    ProxyProvider<CommunityRepository, GetMyGroups>(
      update: (_, repository, __) => GetMyGroups(repository),
    ),

    // Join Community Use Case
    ProxyProvider<CommunityRepository, JoinCommunity>(
      update: (_, repository, __) => JoinCommunity(repository),
    ),

    // ========================================
    // VCHAT COMMUNITY PROVIDER
    // ========================================

    // VChat Provider
    ChangeNotifierProxyProvider3<
      GetRecommendedCommunities,
      GetMyGroups,
      JoinCommunity,
      VChatProvider
    >(
      create: (context) => VChatProvider(
        getRecommendedCommunities: context.read<GetRecommendedCommunities>(),
        getMyGroups: context.read<GetMyGroups>(),
        joinCommunity: context.read<JoinCommunity>(),
      ),
      update:
          (
            _,
            getRecommendedCommunities,
            getMyGroups,
            joinCommunity,
            previous,
          ) =>
              previous ??
              VChatProvider(
                getRecommendedCommunities: getRecommendedCommunities,
                getMyGroups: getMyGroups,
                joinCommunity: joinCommunity,
              ),
    ),
  ];

  /// Route paths constants
  static const String vchatHomePath = '/chat';
  static const String chatScreenPath = '/chat/:chatId';

  /// Helper methods for chat navigation
  static String buildChatScreenRoute(String chatId) {
    return '/chat/$chatId';
  }

  /// Provider categories for analytics and organization
  static const List<String> chatScreenProviders = [
    'ChatRemoteDataSource',
    'SocketDataSource',
    'ChatRepository',
    'FetchMessages',
    'SendMessage',
    'UploadMedia',
    'ChatProvider',
  ];

  static const List<String> vchatProviders = [
    'CommunityRemoteDataSource',
    'CommunityRepository',
    'GetRecommendedCommunities',
    'GetMyGroups',
    'JoinCommunity',
    'VChatProvider',
  ];

  /// Helper methods to check provider categories
  static bool isChatScreenProvider(String providerName) {
    return chatScreenProviders.contains(providerName);
  }

  static bool isVChatProvider(String providerName) {
    return vchatProviders.contains(providerName);
  }

  /// Get all chat providers
  static List<String> get allChatProviders => [
    ...chatScreenProviders,
    ...vchatProviders,
  ];

  /// Validate if a given provider is valid chat provider
  static bool isValidChatProvider(String providerName) {
    return allChatProviders.contains(providerName);
  }

  /// Get provider display name from name
  static String getProviderDisplayName(String providerName) {
    switch (providerName) {
      case 'ChatProvider':
        return 'Chat Provider';
      case 'VChatProvider':
        return 'VChat Provider';
      case 'ChatRepository':
        return 'Chat Repository';
      case 'CommunityRepository':
        return 'Community Repository';
      default:
        return providerName;
    }
  }

  /// Get provider description for UI
  static String getProviderDescription(String providerName) {
    switch (providerName) {
      case 'ChatProvider':
        return 'Manages chat messages and real-time communication';
      case 'VChatProvider':
        return 'Manages communities and group functionality';
      case 'ChatRepository':
        return 'Handles chat data operations and socket connections';
      case 'CommunityRepository':
        return 'Handles community data operations';
      default:
        return 'Chat module provider';
    }
  }

  /// Build chat navigation menu items
  static List<Map<String, dynamic>> getChatMenuItems() {
    return [
      {
        'title': 'Communities',
        'subtitle': 'Join and explore communities',
        'path': vchatHomePath,
        'icon': 'groups',
        'enabled': true,
      },
      {
        'title': 'Personal Chats',
        'subtitle': 'Direct messages',
        'path': '/personal-chat',
        'icon': 'chat_bubble',
        'enabled': true,
      },
    ];
  }

  /// Get breadcrumb for chat routes
  static List<Map<String, String>> getBreadcrumb(String currentPath) {
    final breadcrumbs = <Map<String, String>>[
      {'title': 'Home', 'path': '/home'},
    ];

    if (currentPath.startsWith('/chat')) {
      breadcrumbs.add({'title': 'Chat', 'path': vchatHomePath});

      if (currentPath != vchatHomePath) {
        // Extract chat ID if it's a specific chat
        final segments = currentPath.split('/');
        if (segments.length > 2) {
          breadcrumbs.add({'title': 'Conversation', 'path': currentPath});
        }
      }
    }

    return breadcrumbs;
  }
}
