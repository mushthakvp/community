import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client_wrapper.dart';
import '../../features/chat_module/vchat/data/datasources/chat_local_datasource.dart';
import '../../features/chat_module/vchat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat_module/vchat/data/repositories/chat_repository_impl.dart';
import '../../features/chat_module/vchat/domain/repositories/chat_repository.dart';
import '../../features/chat_module/vchat/domain/usecases/create_community_usecase.dart';
import '../../features/chat_module/vchat/domain/usecases/get_birthday_friends_usecase.dart';
import '../../features/chat_module/vchat/domain/usecases/get_communities_usecase.dart';
import '../../features/chat_module/vchat/domain/usecases/get_friends_usecase.dart';
import '../../features/chat_module/vchat/domain/usecases/get_messages_usecase.dart';
import '../../features/chat_module/vchat/domain/usecases/manage_friend_requests_usecase.dart';
import '../../features/chat_module/vchat/domain/usecases/send_birthday_wish_usecase.dart';
import '../../features/chat_module/vchat/domain/usecases/send_message_usecase.dart';
import '../../features/chat_module/vchat/presentation/providers/chat_provider.dart';
import '../../features/chat_module/vchat/presentation/providers/community_provider.dart';
import '../../features/chat_module/vchat/presentation/providers/message_provider.dart';

class VChatProviders {
  static List<SingleChildWidget> get providers => [
    // ========================================
    // CHAT DATA SOURCES
    // ========================================

    // Local Data Source
    ProxyProvider<SharedPreferences, ChatLocalDataSource>(
      update: (_, prefs, __) => ChatLocalDataSourceImpl(prefs: prefs),
    ),

    // Remote Data Source - Uses the Chat API Client from wrapper
    ProxyProvider<ApiClientWrapper, ChatRemoteDataSource>(
      update: (_, apiWrapper, __) =>
          ChatRemoteDataSourceImpl(apiClient: apiWrapper.chatClient),
    ),

    // ========================================
    // CHAT REPOSITORY
    // ========================================
    ProxyProvider2<ChatRemoteDataSource, ChatLocalDataSource, ChatRepository>(
      update: (_, remoteDataSource, localDataSource, __) => ChatRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
      ),
    ),

    // ... rest of your use cases and providers remain the same
    // ========================================
    // CHAT USE CASES
    // ========================================
    ProxyProvider<ChatRepository, GetCommunitiesUseCase>(
      update: (_, repository, __) => GetCommunitiesUseCase(repository),
    ),

    ProxyProvider<ChatRepository, GetFriendsUseCase>(
      update: (_, repository, __) => GetFriendsUseCase(repository),
    ),

    ProxyProvider<ChatRepository, GetBirthdayFriendsUseCase>(
      update: (_, repository, __) => GetBirthdayFriendsUseCase(repository),
    ),

    ProxyProvider<ChatRepository, ManageFriendRequestsUseCase>(
      update: (_, repository, __) => ManageFriendRequestsUseCase(repository),
    ),

    ProxyProvider<ChatRepository, SendBirthdayWishUseCase>(
      update: (_, repository, __) => SendBirthdayWishUseCase(repository),
    ),

    ProxyProvider<ChatRepository, CreateCommunityUseCase>(
      update: (_, repository, __) => CreateCommunityUseCase(repository),
    ),

    ProxyProvider<ChatRepository, GetMessagesUseCase>(
      update: (_, repository, __) => GetMessagesUseCase(repository),
    ),

    ProxyProvider<ChatRepository, SendMessageUseCase>(
      update: (_, repository, __) => SendMessageUseCase(repository),
    ),

    // ========================================
    // CHAT PROVIDERS
    // ========================================
    ChangeNotifierProxyProvider5<
      GetCommunitiesUseCase,
      GetFriendsUseCase,
      GetBirthdayFriendsUseCase,
      ManageFriendRequestsUseCase,
      SendBirthdayWishUseCase,
      ChatProvider
    >(
      create: (context) => ChatProvider(
        getCommunitiesUseCase: context.read<GetCommunitiesUseCase>(),
        getFriendsUseCase: context.read<GetFriendsUseCase>(),
        getBirthdayFriendsUseCase: context.read<GetBirthdayFriendsUseCase>(),
        manageFriendRequestsUseCase: context
            .read<ManageFriendRequestsUseCase>(),
        sendBirthdayWishUseCase: context.read<SendBirthdayWishUseCase>(),
      ),
      update:
          (
            _,
            getCommunitiesUseCase,
            getFriendsUseCase,
            getBirthdayFriendsUseCase,
            manageFriendRequestsUseCase,
            sendBirthdayWishUseCase,
            previous,
          ) =>
              previous ??
              ChatProvider(
                getCommunitiesUseCase: getCommunitiesUseCase,
                getFriendsUseCase: getFriendsUseCase,
                getBirthdayFriendsUseCase: getBirthdayFriendsUseCase,
                manageFriendRequestsUseCase: manageFriendRequestsUseCase,
                sendBirthdayWishUseCase: sendBirthdayWishUseCase,
              ),
    ),

    ChangeNotifierProvider<CommunityProvider>(
      create: (context) => CommunityProvider(),
    ),

    ChangeNotifierProvider<MessageProvider>(
      create: (context) => MessageProvider(),
    ),
  ];
}
