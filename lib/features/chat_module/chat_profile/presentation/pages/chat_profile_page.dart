import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/widgets/common/loading_widget.dart';
import '../../../../../core/widgets/error_widget.dart';
import '../providers/chat_profile_provider.dart';
import '../widgets/member_list_item.dart';
import '../widgets/member_request_item.dart';
import '../widgets/member_search_field.dart';
import '../widgets/profile_header.dart';

class ChatProfilePage extends StatefulWidget {
  final String chatId;
  final String? chatName;
  final String? chatImage;
  final bool isGroup;

  const ChatProfilePage({
    super.key,
    required this.chatId,
    this.chatName,
    this.chatImage,
    this.isGroup = false,
  });

  @override
  State<ChatProfilePage> createState() => _ChatProfilePageState();
}

class _ChatProfilePageState extends State<ChatProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProfileProvider>().initializeCommunityProfile(
        widget.chatId,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
          ),
        ),
        child: Consumer<ChatProfileProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return _buildLoadingState();
            }

            if (provider.hasError) {
              return _buildErrorState(provider);
            }

            if (provider.communityInfo == null) {
              return _buildEmptyState();
            }

            return _buildMainContent(provider);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: LoadingWidget(message: 'Loading community profile...'),
    );
  }

  Widget _buildErrorState(ChatProfileProvider provider) {
    return Center(
      child: CustomErrorWidget(
        message: provider.errorMessage ?? 'Something went wrong',
        onRetry: () => provider.initializeCommunityProfile(widget.chatId),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Community not found',
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(ChatProfileProvider provider) {
    final isCreator = provider.isCreator;
    final isUserInGroup = provider.isUserInGroup;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Sliver App Bar with Profile Header
        SliverAppBar(
          expandedHeight: 300.0,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          actions: [
            if (!isCreator && isUserInGroup)
              _buildLeaveCommunityButton(provider),
          ],
          flexibleSpace: FlexibleSpaceBar(
            // Remove title to prevent overlap with profile text
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
                ),
              ),
              child: SafeArea(
                child: ProfileHeader(
                  communityInfo: provider.communityInfo!,
                  memberCount: provider.totalMemberCount,
                ),
              ),
            ),
          ),
        ),

        // Tab selector for creators (improved design)
        if (isCreator) ...[
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[700]!, width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _tabController.animateTo(0),
                      child: AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, child) {
                          final isSelected = _tabController.index == 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppConstants.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Members (${provider.totalMemberCount})',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[400],
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _tabController.animateTo(1),
                      child: AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, child) {
                          final isSelected = _tabController.index == 1;
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppConstants.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Requests (${provider.totalRequestCount})',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[400],
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // Content based on tab selection or member view
        if (isCreator) ...[
          // Tab content for creators
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, child) {
              if (_tabController.index == 0) {
                return _buildMembersContent(provider);
              } else {
                return _buildRequestsContent(provider);
              }
            },
          ),
        ] else ...[
          // Members content for regular users
          _buildMembersContent(provider),
        ],
      ],
    );
  }

  Widget _buildMembersContent(ChatProfileProvider provider) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // Search Field
        if (provider.totalMemberCount > 4)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MemberSearchField(
              controller: provider.memberSearchController,
              onChanged: provider.searchMembers,
              hintText: 'Search members...',
            ),
          ),

        // Members List
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              if (provider.hasMembers) ...[
                for (int index = 0; index < provider.members.length; index++)
                  MemberListItem(
                    member: provider.members[index],
                    isCreator: provider.isCreator,
                    onRemove: null, // Removed functionality
                    onSendFriendRequest:
                        !provider.members[index].isFriend &&
                            !provider.members[index].isRequested &&
                            !provider.members[index].isCurrentUser
                        ? () => provider.sendFriendRequestToUser(
                            provider.members[index].id,
                            index,
                          )
                        : null,
                    onChat:
                        provider.members[index].isFriend &&
                            !provider.members[index].isCurrentUser
                        ? () => _navigateToChat(provider.members[index])
                        : null,
                    isLoading: provider.isRequestLoading,
                  ),
              ] else ...[
                const SizedBox(height: 100),
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.group_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No members found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // Bottom spacing
        const SizedBox(height: 100),
      ]),
    );
  }

  Widget _buildRequestsContent(ChatProfileProvider provider) {
    return SliverList(
      delegate: SliverChildListDelegate([
        if (provider.hasRequests) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (
                  int index = 0;
                  index < provider.memberRequests!.requests.length;
                  index++
                )
                  MemberRequestItem(
                    request: provider.memberRequests!.requests[index],
                    onApprove: () => provider.approveJoinRequest(
                      provider.memberRequests!.requests[index].id,
                      index,
                    ),
                    onReject: () => provider.rejectJoinRequest(
                      provider.memberRequests!.requests[index].id,
                      index,
                    ),
                    isLoading: provider.isRequestLoading,
                  ),
              ],
            ),
          ),
        ] else ...[
          const SizedBox(height: 100),
          const Center(
            child: Column(
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No pending requests',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ],

        // Bottom spacing
        const SizedBox(height: 100),
      ]),
    );
  }

  Widget _buildLeaveCommunityButton(ChatProfileProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () => _showLeaveCommunityDialog(provider),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: const Text(
            'Leave',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToChat(member) {
    context.pushNamed(
      'singleChat',
      pathParameters: {'chatId': member.id},
      queryParameters: {
        'chatName': member.name,
        'chatImage': member.profileImage ?? '',
      },
    );
  }

  void _showLeaveCommunityDialog(ChatProfileProvider provider) {
    AppUtils.showConfirmationDialog(
      context: context,
      title: 'Leave Community',
      message: 'Are you sure you want to leave this community?',
      confirmText: 'Leave',
      isDestructive: true,
      onConfirm: () async {
        await provider.leaveCommunityAction();
        if (mounted) {
          context.pop();
        }
      },
    );
  }
}
