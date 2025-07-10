import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/chat_api_constants.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_info.dart';
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
    // Chat API Client
    Provider<ApiClient>(
      create: (context) => ApiClient(
        baseUrl: ChatApiConstants.chatBaseUrl,
        networkInfo: context.read<NetworkInfo>(),
      ),
      lazy: false,
    ),

    // Data Sources
    Provider<ChatLocalDataSource>(
      create: (context) =>
          ChatLocalDataSourceImpl(prefs: context.read<SharedPreferences>()),
    ),

    Provider<ChatRemoteDataSource>(
      create: (context) =>
          ChatRemoteDataSourceImpl(apiClient: context.read<ApiClient>()),
    ),

    // Repository
    Provider<ChatRepository>(
      create: (context) => ChatRepositoryImpl(
        remoteDataSource: context.read<ChatRemoteDataSource>(),
        localDataSource: context.read<ChatLocalDataSource>(),
      ),
    ),

    // Use Cases
    Provider<GetCommunitiesUseCase>(
      create: (context) =>
          GetCommunitiesUseCase(context.read<ChatRepository>()),
    ),

    Provider<GetFriendsUseCase>(
      create: (context) => GetFriendsUseCase(context.read<ChatRepository>()),
    ),

    Provider<GetBirthdayFriendsUseCase>(
      create: (context) =>
          GetBirthdayFriendsUseCase(context.read<ChatRepository>()),
    ),

    Provider<ManageFriendRequestsUseCase>(
      create: (context) =>
          ManageFriendRequestsUseCase(context.read<ChatRepository>()),
    ),

    Provider<SendBirthdayWishUseCase>(
      create: (context) =>
          SendBirthdayWishUseCase(context.read<ChatRepository>()),
    ),

    Provider<CreateCommunityUseCase>(
      create: (context) =>
          CreateCommunityUseCase(context.read<ChatRepository>()),
    ),

    Provider<GetMessagesUseCase>(
      create: (context) => GetMessagesUseCase(context.read<ChatRepository>()),
    ),

    Provider<SendMessageUseCase>(
      create: (context) => SendMessageUseCase(context.read<ChatRepository>()),
    ),

    // Providers
    ChangeNotifierProvider<ChatProvider>(
      create: (context) => ChatProvider(
        getCommunitiesUseCase: context.read<GetCommunitiesUseCase>(),
        getFriendsUseCase: context.read<GetFriendsUseCase>(),
        getBirthdayFriendsUseCase: context.read<GetBirthdayFriendsUseCase>(),
        manageFriendRequestsUseCase: context
            .read<ManageFriendRequestsUseCase>(),
        sendBirthdayWishUseCase: context.read<SendBirthdayWishUseCase>(),
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
