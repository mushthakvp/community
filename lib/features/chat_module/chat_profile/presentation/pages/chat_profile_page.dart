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
import 'add_member_page.dart';
import 'members_list_page.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProfileProvider>().initializeCommunityProfile(
        widget.chatId,
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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

    return Column(
      children: [
        // Custom App Bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (!isCreator && isUserInGroup)
                  _buildLeaveCommunityButton(provider),
              ],
            ),
          ),
        ),

        // Profile Header
        ProfileHeader(
          communityInfo: provider.communityInfo!,
          memberCount: provider.totalMemberCount,
        ),

        const SizedBox(height: 20),

        if (isCreator) ...[
          // Tab Bar for Creator
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[400],
              indicator: BoxDecoration(
                color: AppConstants.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              tabs: [
                Tab(text: 'Members (${provider.totalMemberCount})'),
                Tab(text: 'Requests (${provider.totalRequestCount})'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMembersTab(provider),
                _buildRequestsTab(provider),
              ],
            ),
          ),
        ] else ...[
          // Members list for non-creators
          _buildMembersSection(provider),
        ],
      ],
    );
  }

  Widget _buildLeaveCommunityButton(ChatProfileProvider provider) {
    return GestureDetector(
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
    );
  }

  Widget _buildMembersTab(ChatProfileProvider provider) {
    return Column(
      children: [
        // Search and Add Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: MemberSearchField(
                  controller: provider.memberSearchController,
                  onChanged: provider.searchMembers,
                  hintText: 'Search members...',
                ),
              ),
              const SizedBox(width: 12),
              _buildAddMemberButton(),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Members List
        Expanded(child: _buildMembersList(provider)),
      ],
    );
  }

  Widget _buildRequestsTab(ChatProfileProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.refreshRequests,
      child: provider.hasRequests
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: provider.memberRequests!.requests.length,
              itemBuilder: (context, index) {
                final request = provider.memberRequests!.requests[index];
                return MemberRequestItem(
                  request: request,
                  onApprove: () =>
                      provider.approveJoinRequest(request.id, index),
                  onReject: () => provider.rejectJoinRequest(request.id, index),
                  isLoading: provider.isRequestLoading,
                );
              },
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget _buildMembersSection(ChatProfileProvider provider) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Members (${provider.totalMemberCount})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (provider.totalMemberCount > 10)
                  TextButton(
                    onPressed: () => _navigateToMembersList(),
                    child: const Text('View All'),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (provider.totalMemberCount > 4)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MemberSearchField(
                controller: provider.memberSearchController,
                onChanged: provider.searchMembers,
                hintText: 'Search members...',
              ),
            ),

          const SizedBox(height: 16),

          Expanded(child: _buildMembersList(provider)),
        ],
      ),
    );
  }

  Widget _buildMembersList(ChatProfileProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.refreshMembers,
      child: provider.hasMembers
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: provider.members.length,
              itemBuilder: (context, index) {
                final member = provider.members[index];
                return MemberListItem(
                  member: member,
                  isCreator: provider.isCreator,
                  onRemove: provider.isCreator && !member.isCurrentUser
                      ? () => _showRemoveMemberDialog(provider, member, index)
                      : null,
                  onSendFriendRequest:
                      !member.isFriend &&
                          !member.isRequested &&
                          !member.isCurrentUser
                      ? () => provider.sendFriendRequestToUser(member.id, index)
                      : null,
                  onChat: member.isFriend && !member.isCurrentUser
                      ? () => _navigateToChat(member)
                      : null,
                  isLoading: provider.isRequestLoading,
                );
              },
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget _buildAddMemberButton() {
    return GestureDetector(
      onTap: _navigateToAddMember,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstants.primary,
              AppConstants.primary.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.person_add, color: Colors.white, size: 24),
      ),
    );
  }

  void _navigateToMembersList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MembersListPage(
          communityId: widget.chatId,
          communityName: widget.chatName ?? 'Community',
        ),
      ),
    );
  }

  void _navigateToAddMember() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberPage(
          communityId: widget.chatId,
          communityName: widget.chatName ?? 'Community',
        ),
      ),
    );
  }

  void _navigateToChat(member) {
    // Navigate to single chat - you'll need to implement this based on your routing
    context.pushNamed(
      'singleChat', // Replace with your chat route name
      pathParameters: {'chatId': member.id},
      queryParameters: {
        'chatName': member.name,
        'chatImage': member.profileImage ?? '',
      },
    );
  }

  void _showRemoveMemberDialog(
    ChatProfileProvider provider,
    member,
    int index,
  ) {
    AppUtils.showConfirmationDialog(
      context: context,
      title: 'Remove Member',
      message:
          'Are you sure you want to remove ${member.name} from the community?',
      confirmText: 'Remove',
      isDestructive: true,
      onConfirm: () => provider.removeMemberFromCommunity(member.id, index),
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
          context.pop(); // Go back after leaving
        }
      },
    );
  }
}
