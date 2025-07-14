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
          expandedHeight: 350.0,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            if (!isCreator && isUserInGroup)
              _buildLeaveCommunityButton(provider),
          ],
          flexibleSpace: FlexibleSpaceBar(
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

        // Tab Bar (only for creators)
        if (isCreator)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[400],
                indicator: BoxDecoration(
                  color: AppConstants.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(text: 'Members (${provider.totalMemberCount})'),
                  Tab(text: 'Requests (${provider.totalRequestCount})'),
                ],
              ),
            ),
          ),

        // Content
        if (isCreator)
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMembersTab(provider),
                _buildRequestsTab(provider),
              ],
            ),
          )
        else
          SliverToBoxAdapter(child: _buildMembersSection(provider)),
      ],
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

  Widget _buildMembersTab(ChatProfileProvider provider) {
    return Column(
      children: [
        // Search Field (removed Add Button)
        Padding(
          padding: const EdgeInsets.all(16),
          child: MemberSearchField(
            controller: provider.memberSearchController,
            onChanged: provider.searchMembers,
            hintText: 'Search members...',
          ),
        ),

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
    return Column(
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

        // Make members list scrollable
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: _buildMembersList(provider),
        ),
      ],
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
                  // Removed onRemove - no longer needed
                  onRemove: null,
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

// Custom Sliver Tab Bar Delegate for pinned tab bar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height + 20;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 20;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
