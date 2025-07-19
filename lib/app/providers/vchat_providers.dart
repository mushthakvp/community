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
// Create Community Imports
import '../../features/chat_module/create_community/data/datasources/community_remote_datasource.dart'
    as create_community;
import '../../features/chat_module/create_community/data/repositories/community_repository_impl.dart'
    as create_community;
import '../../features/chat_module/create_community/domain/repositories/community_repository.dart'
    as create_community;
import '../../features/chat_module/create_community/domain/usecases/create_community.dart';
import '../../features/chat_module/create_community/domain/usecases/delete_community.dart';
import '../../features/chat_module/create_community/domain/usecases/get_community_details.dart';
import '../../features/chat_module/create_community/domain/usecases/join_community.dart'
    as create_community;
import '../../features/chat_module/create_community/domain/usecases/leave_community.dart'
    as create_community;
import '../../features/chat_module/create_community/domain/usecases/update_community.dart';
import '../../features/chat_module/create_community/domain/usecases/upload_profile_image.dart';
import '../../features/chat_module/create_community/presentation/providers/community_provider.dart';
// Personal Chat Imports - ADD THESE IMPORTS
import '../../features/chat_module/personal_chat/data/datasources/personal_chat_remote_datasource.dart';
import '../../features/chat_module/personal_chat/data/repositories/personal_chat_repository_impl.dart';
import '../../features/chat_module/personal_chat/domain/repositories/personal_chat_repository.dart';
// VChat Community Imports
import '../../features/chat_module/vchat/data/datasources/community_remote_datasource.dart';
import '../../features/chat_module/vchat/data/repositories/community_repository_impl.dart';
import '../../features/chat_module/vchat/domain/repositories/community_repository.dart';
import '../../features/chat_module/vchat/domain/usecases/get_my_groups.dart';
import '../../features/chat_module/vchat/domain/usecases/get_recommended_communities.dart';
import '../../features/chat_module/vchat/domain/usecases/join_community.dart';
import '../../features/chat_module/vchat/presentation/providers/vchat_provider.dart';

/// Enhanced Chat module providers for messaging, community features, profile management, and community creation
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
    // PERSONAL CHAT DATA SOURCES - ADD THESE
    // ========================================

    // Personal Chat Remote Data Source (uses chat API client)
    ProxyProvider<ApiClientWrapper, PersonalChatRemoteDataSource>(
      update: (_, wrapper, __) =>
          PersonalChatRemoteDataSourceImpl(apiClient: wrapper.chatClient),
    ),

    // ========================================
    // CREATE COMMUNITY DATA SOURCES
    // ========================================

    // Create Community Remote Data Source (uses chat API client)
    ProxyProvider<ApiClientWrapper, create_community.CommunityRemoteDataSource>(
      update: (_, wrapper, __) =>
          create_community.CommunityRemoteDataSourceImpl(
            apiClient: wrapper.chatClient,
          ),
    ),

    // ========================================
    // VCHAT COMMUNITY DATA SOURCES
    // ========================================

    // VChat Community Remote Data Source (uses chat API client)
    ProxyProvider<ApiClientWrapper, CommunityRemoteDataSource>(
      update: (_, wrapper, __) =>
          CommunityRemoteDataSourceImpl(apiClient: wrapper.chatClient),
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

    // Personal Chat Repository - ADD THIS
    ProxyProvider2<
      PersonalChatRemoteDataSource,
      SocketDataSource,
      PersonalChatRepository
    >(
      update: (_, remoteDataSource, socketDataSource, __) =>
          PersonalChatRepositoryImpl(
            remoteDataSource: remoteDataSource,
            socketDataSource: socketDataSource,
          ),
    ),

    // Create Community Repository
    ProxyProvider2<
      create_community.CommunityRemoteDataSource,
      NetworkInfo,
      create_community.CommunityRepository
    >(
      update: (_, remoteDataSource, networkInfo, __) =>
          create_community.CommunityRepositoryImpl(
            remoteDataSource: remoteDataSource,
            networkInfo: networkInfo,
          ),
    ),

    // VChat Community Repository
    ProxyProvider<CommunityRemoteDataSource, CommunityRepository>(
      update: (_, remoteDataSource, __) =>
          CommunityRepositoryImpl(remoteDataSource: remoteDataSource),
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
    // CREATE COMMUNITY USE CASES
    // ========================================

    // Create Community Use Case
    ProxyProvider<create_community.CommunityRepository, CreateCommunity>(
      update: (_, repository, __) => CreateCommunity(repository),
    ),

    // Update Community Use Case
    ProxyProvider<create_community.CommunityRepository, UpdateCommunity>(
      update: (_, repository, __) => UpdateCommunity(repository),
    ),

    // Get Community Details Use Case
    ProxyProvider<create_community.CommunityRepository, GetCommunityDetails>(
      update: (_, repository, __) => GetCommunityDetails(repository),
    ),

    // Delete Community Use Case
    ProxyProvider<create_community.CommunityRepository, DeleteCommunity>(
      update: (_, repository, __) => DeleteCommunity(repository),
    ),

    // Upload Profile Image Use Case
    ProxyProvider<create_community.CommunityRepository, UploadProfileImage>(
      update: (_, repository, __) => UploadProfileImage(repository),
    ),

    // Join Community Use Case (Create Community)
    ProxyProvider<
      create_community.CommunityRepository,
      create_community.JoinCommunity
    >(
      update: (_, repository, __) => create_community.JoinCommunity(repository),
    ),

    // Leave Community Use Case (Create Community)
    ProxyProvider<
      create_community.CommunityRepository,
      create_community.LeaveCommunity
    >(
      update: (_, repository, __) =>
          create_community.LeaveCommunity(repository),
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

    // Join Community Use Case (VChat)
    ProxyProvider<CommunityRepository, JoinCommunity>(
      update: (_, repository, __) => JoinCommunity(repository),
    ),

    // ========================================
    // PROVIDERS
    // ========================================

    // Chat Provider - UPDATED TO INCLUDE PersonalChatRepository
    ChangeNotifierProxyProvider5<
      FetchMessages,
      SendMessage,
      UploadMedia,
      ChatRepository,
      PersonalChatRepository,
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
        personalChatRepository: context.read<PersonalChatRepository>(),
      ),
      update:
          (
            _,
            fetchMessages,
            sendMessage,
            uploadMedia,
            chatRepository,
            personalChatRepository,
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
                personalChatRepository: personalChatRepository,
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

    // Community Use Case Bundle 1
    ProxyProvider4<
      CreateCommunity,
      UpdateCommunity,
      GetCommunityDetails,
      UploadProfileImage,
      _CommunityUseCaseBundle1
    >(
      update:
          (
            _,
            createCommunity,
            updateCommunity,
            getCommunityDetails,
            uploadProfileImage,
            __,
          ) => _CommunityUseCaseBundle1(
            createCommunity: createCommunity,
            updateCommunity: updateCommunity,
            getCommunityDetails: getCommunityDetails,
            uploadProfileImage: uploadProfileImage,
          ),
    ),

    // Community Use Case Bundle 2
    ProxyProvider3<
      DeleteCommunity,
      create_community.JoinCommunity,
      create_community.LeaveCommunity,
      _CommunityUseCaseBundle2
    >(
      update: (_, deleteCommunity, joinCommunity, leaveCommunity, __) =>
          _CommunityUseCaseBundle2(
            deleteCommunity: deleteCommunity,
            joinCommunity: joinCommunity,
            leaveCommunity: leaveCommunity,
          ),
    ),

    // Community Provider (for creating/editing communities)
    ChangeNotifierProxyProvider2<
      _CommunityUseCaseBundle1,
      _CommunityUseCaseBundle2,
      CommunityProvider
    >(
      create: (context) {
        final bundle1 = context.read<_CommunityUseCaseBundle1>();
        final bundle2 = context.read<_CommunityUseCaseBundle2>();
        return CommunityProvider(
          createCommunityUseCase: bundle1.createCommunity,
          updateCommunityUseCase: bundle1.updateCommunity,
          getCommunityDetailsUseCase: bundle1.getCommunityDetails,
          uploadProfileImageUseCase: bundle1.uploadProfileImage,
          deleteCommunityUseCase: bundle2.deleteCommunity,
          joinCommunityUseCase: bundle2.joinCommunity,
          leaveCommunityUseCase: bundle2.leaveCommunity,
        );
      },
      update: (_, bundle1, bundle2, previous) =>
          previous ??
          CommunityProvider(
            createCommunityUseCase: bundle1.createCommunity,
            updateCommunityUseCase: bundle1.updateCommunity,
            getCommunityDetailsUseCase: bundle1.getCommunityDetails,
            uploadProfileImageUseCase: bundle1.uploadProfileImage,
            deleteCommunityUseCase: bundle2.deleteCommunity,
            joinCommunityUseCase: bundle2.joinCommunity,
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

class _CommunityUseCaseBundle1 {
  final CreateCommunity createCommunity;
  final UpdateCommunity updateCommunity;
  final GetCommunityDetails getCommunityDetails;
  final UploadProfileImage uploadProfileImage;

  _CommunityUseCaseBundle1({
    required this.createCommunity,
    required this.updateCommunity,
    required this.getCommunityDetails,
    required this.uploadProfileImage,
  });
}

class _CommunityUseCaseBundle2 {
  final DeleteCommunity deleteCommunity;
  final create_community.JoinCommunity joinCommunity;
  final create_community.LeaveCommunity leaveCommunity;

  _CommunityUseCaseBundle2({
    required this.deleteCommunity,
    required this.joinCommunity,
    required this.leaveCommunity,
  });
}
