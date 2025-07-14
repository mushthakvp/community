import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/network/api_client_wrapper.dart';
import '../../core/network/network_info.dart';
// Chat Profile Imports
import '../../features/chat_module/chat_profile/data/datasources/chat_profile_local_datasource.dart';
import '../../features/chat_module/chat_profile/data/datasources/chat_profile_remote_datasource.dart';
import '../../features/chat_module/chat_profile/data/repositories/chat_profile_repository_impl.dart';
import '../../features/chat_module/chat_profile/domain/repositories/chat_profile_repository.dart';
import '../../features/chat_module/chat_profile/domain/usecases/add_members.dart';
import '../../features/chat_module/chat_profile/domain/usecases/approve_request.dart';
import '../../features/chat_module/chat_profile/domain/usecases/get_community_info.dart';
import '../../features/chat_module/chat_profile/domain/usecases/get_community_members.dart';
import '../../features/chat_module/chat_profile/domain/usecases/get_friends.dart';
import '../../features/chat_module/chat_profile/domain/usecases/get_member_requests.dart';
import '../../features/chat_module/chat_profile/domain/usecases/leave_community.dart';
import '../../features/chat_module/chat_profile/domain/usecases/reject_request.dart';
import '../../features/chat_module/chat_profile/domain/usecases/remove_member.dart';
import '../../features/chat_module/chat_profile/domain/usecases/send_friend_request.dart';
import '../../features/chat_module/chat_profile/presentation/providers/chat_profile_provider.dart';
// Chat Screen Imports
import '../../features/chat_module/chat_screen/data/datasources/chat_remote_datasource.dart';
import '../../features/chat_module/chat_screen/data/datasources/socket_datasource.dart';
import '../../features/chat_module/chat_screen/data/repositories/chat_repository_impl.dart';
import '../../features/chat_module/chat_screen/domain/repositories/chat_repository.dart';
import '../../features/chat_module/chat_screen/domain/usecases/fetch_messages.dart';
import '../../features/chat_module/chat_screen/domain/usecases/send_message.dart';
import '../../features/chat_module/chat_screen/domain/usecases/upload_media.dart';
import '../../features/chat_module/chat_screen/presentation/providers/chat_provider.dart';
// VChat Community Imports
import '../../features/chat_module/vchat/data/datasources/community_remote_datasource.dart';
import '../../features/chat_module/vchat/data/repositories/community_repository_impl.dart';
import '../../features/chat_module/vchat/domain/repositories/community_repository.dart';
import '../../features/chat_module/vchat/domain/usecases/get_my_groups.dart';
import '../../features/chat_module/vchat/domain/usecases/get_recommended_communities.dart';
import '../../features/chat_module/vchat/domain/usecases/join_community.dart';
import '../../features/chat_module/vchat/presentation/providers/vchat_provider.dart';

/// Enhanced Chat module providers for messaging, community features, and profile management
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
    // CHAT PROFILE DATA SOURCES
    // ========================================

    // Chat Profile Remote Data Source (uses chat API client)
    ProxyProvider<ApiClientWrapper, ChatProfileRemoteDataSource>(
      update: (_, wrapper, __) =>
          ChatProfileRemoteDataSourceImpl(apiClient: wrapper.chatClient),
    ),

    // Chat Profile Local Data Source
    Provider<ChatProfileLocalDataSource>(
      create: (_) => ChatProfileLocalDataSourceImpl(),
    ),

    // ========================================
    // REPOSITORIES
    // ========================================

    // Chat Repository
    ProxyProvider2<ChatRemoteDataSource, SocketDataSource, ChatRepository>(
      update: (_, remoteDataSource, socketDataSource, __) => ChatRepositoryImpl(
        remoteDataSource: remoteDataSource,
        socketDataSource: socketDataSource,
      ),
    ),

    // Chat Profile Repository
    ProxyProvider3<
      ChatProfileRemoteDataSource,
      ChatProfileLocalDataSource,
      NetworkInfo,
      ChatProfileRepository
    >(
      update: (_, remoteDataSource, localDataSource, networkInfo, __) =>
          ChatProfileRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            networkInfo: networkInfo,
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
    // CHAT PROFILE USE CASES
    // ========================================

    // Get Community Members Use Case
    ProxyProvider<ChatProfileRepository, GetCommunityMembers>(
      update: (_, repository, __) => GetCommunityMembers(repository),
    ),

    // Get Member Requests Use Case
    ProxyProvider<ChatProfileRepository, GetMemberRequests>(
      update: (_, repository, __) => GetMemberRequests(repository),
    ),

    // Add Members Use Case
    ProxyProvider<ChatProfileRepository, AddMembers>(
      update: (_, repository, __) => AddMembers(repository),
    ),

    // Remove Member Use Case
    ProxyProvider<ChatProfileRepository, RemoveMember>(
      update: (_, repository, __) => RemoveMember(repository),
    ),

    // Approve Request Use Case
    ProxyProvider<ChatProfileRepository, ApproveRequest>(
      update: (_, repository, __) => ApproveRequest(repository),
    ),

    // Reject Request Use Case
    ProxyProvider<ChatProfileRepository, RejectRequest>(
      update: (_, repository, __) => RejectRequest(repository),
    ),

    // Send Friend Request Use Case
    ProxyProvider<ChatProfileRepository, SendFriendRequest>(
      update: (_, repository, __) => SendFriendRequest(repository),
    ),

    // Get Friends Use Case
    ProxyProvider<ChatProfileRepository, GetFriends>(
      update: (_, repository, __) => GetFriends(repository),
    ),

    // Get Community Info Use Case
    ProxyProvider<ChatProfileRepository, GetCommunityInfo>(
      update: (_, repository, __) => GetCommunityInfo(repository),
    ),

    // Leave Community Use Case
    ProxyProvider<ChatProfileRepository, LeaveCommunity>(
      update: (_, repository, __) => LeaveCommunity(repository),
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
    // PROVIDERS
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
        socketDataSource: context.read<SocketDataSource>(),
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
                socketDataSource: SocketDataSourceImpl(),
              ),
    ),

    // Chat Profile Provider (Split into multiple providers due to limitation)
    // First, create a provider for the use case bundle
    ProxyProvider6<
      GetCommunityMembers,
      GetMemberRequests,
      AddMembers,
      RemoveMember,
      ApproveRequest,
      RejectRequest,
      _ChatProfileUseCaseBundle1
    >(
      update:
          (
            _,
            getCommunityMembers,
            getMemberRequests,
            addMembers,
            removeMember,
            approveRequest,
            rejectRequest,
            __,
          ) => _ChatProfileUseCaseBundle1(
            getCommunityMembers: getCommunityMembers,
            getMemberRequests: getMemberRequests,
            addMembers: addMembers,
            removeMember: removeMember,
            approveRequest: approveRequest,
            rejectRequest: rejectRequest,
          ),
    ),

    // Second bundle for remaining use cases
    ProxyProvider4<
      SendFriendRequest,
      GetFriends,
      GetCommunityInfo,
      LeaveCommunity,
      _ChatProfileUseCaseBundle2
    >(
      update:
          (
            _,
            sendFriendRequest,
            getFriends,
            getCommunityInfo,
            leaveCommunity,
            __,
          ) => _ChatProfileUseCaseBundle2(
            sendFriendRequest: sendFriendRequest,
            getFriends: getFriends,
            getCommunityInfo: getCommunityInfo,
            leaveCommunity: leaveCommunity,
          ),
    ),

    // Chat Profile Provider using the bundles
    ChangeNotifierProxyProvider2<
      _ChatProfileUseCaseBundle1,
      _ChatProfileUseCaseBundle2,
      ChatProfileProvider
    >(
      create: (context) {
        final bundle1 = context.read<_ChatProfileUseCaseBundle1>();
        final bundle2 = context.read<_ChatProfileUseCaseBundle2>();
        return ChatProfileProvider(
          getCommunityMembersUseCase: bundle1.getCommunityMembers,
          getMemberRequestsUseCase: bundle1.getMemberRequests,
          addMembersUseCase: bundle1.addMembers,
          removeMemberUseCase: bundle1.removeMember,
          approveRequestUseCase: bundle1.approveRequest,
          rejectRequestUseCase: bundle1.rejectRequest,
          sendFriendRequestUseCase: bundle2.sendFriendRequest,
          getFriendsUseCase: bundle2.getFriends,
          getCommunityInfoUseCase: bundle2.getCommunityInfo,
          leaveCommunityUseCase: bundle2.leaveCommunity,
        );
      },
      update: (_, bundle1, bundle2, previous) =>
          previous ??
          ChatProfileProvider(
            getCommunityMembersUseCase: bundle1.getCommunityMembers,
            getMemberRequestsUseCase: bundle1.getMemberRequests,
            addMembersUseCase: bundle1.addMembers,
            removeMemberUseCase: bundle1.removeMember,
            approveRequestUseCase: bundle1.approveRequest,
            rejectRequestUseCase: bundle1.rejectRequest,
            sendFriendRequestUseCase: bundle2.sendFriendRequest,
            getFriendsUseCase: bundle2.getFriends,
            getCommunityInfoUseCase: bundle2.getCommunityInfo,
            leaveCommunityUseCase: bundle2.leaveCommunity,
          ),
    ),

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
}

// Helper classes to bundle use cases
class _ChatProfileUseCaseBundle1 {
  final GetCommunityMembers getCommunityMembers;
  final GetMemberRequests getMemberRequests;
  final AddMembers addMembers;
  final RemoveMember removeMember;
  final ApproveRequest approveRequest;
  final RejectRequest rejectRequest;

  _ChatProfileUseCaseBundle1({
    required this.getCommunityMembers,
    required this.getMemberRequests,
    required this.addMembers,
    required this.removeMember,
    required this.approveRequest,
    required this.rejectRequest,
  });
}

class _ChatProfileUseCaseBundle2 {
  final SendFriendRequest sendFriendRequest;
  final GetFriends getFriends;
  final GetCommunityInfo getCommunityInfo;
  final LeaveCommunity leaveCommunity;

  _ChatProfileUseCaseBundle2({
    required this.sendFriendRequest,
    required this.getFriends,
    required this.getCommunityInfo,
    required this.leaveCommunity,
  });
}
