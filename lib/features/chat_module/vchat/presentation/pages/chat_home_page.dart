import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat/chat_app_bar.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/community/community_filter_tabs.dart';
import '../widgets/community/community_grid.dart';
import '../widgets/friends/friend_list.dart';
import '../widgets/friends/friend_request_list.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initializeChat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.chatBackgroundColor,
      appBar: const ChatAppBar(),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.isEmpty) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError && provider.isEmpty) {
            return EmptyStateWidget(
              title: 'Something went wrong',
              message: provider.errorMessage ?? 'Please try again',
              onRetry: () => provider.loadInitialData(forceRefresh: true),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshData(),
            child: CustomScrollView(
              slivers: [
                // Banner Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildBannerSection(provider),
                  ),
                ),

                // Filter Tabs (only for My Group)
                if (provider.chatType == 'My Group')
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CommunityFilterTabs(),
                    ),
                  ),

                // Content Section
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: _buildContentSection(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerSection(ChatProvider provider) {
    switch (provider.chatType) {
      case 'Explore':
        return _buildExploreBanner();
      case 'Popular':
        return _buildPopularBanner();
      case 'My Group':
        return _buildMyGroupBanner();
      default:
        return _buildExploreBanner();
    }
  }

  Widget _buildExploreBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF25D366).withOpacity(0.8),
            const Color(0xFF128C7E).withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25D366).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The Ultimate\nMessaging Platform\nfor Social\nConnections',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Discover Communities',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Send Birthday\nGreetings to Your\nConnections',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to birthday wishes page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6C5CE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Share Greetings',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.cake, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildMyGroupBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00B894).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Start Your Own\nCommunity\nToday',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to create community page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF00B894),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Create',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.group_add, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(ChatProvider provider) {
    if (provider.chatType == 'My Group') {
      return _buildMyGroupContent(provider);
    } else {
      return _buildCommunityGrid(provider);
    }
  }

  Widget _buildMyGroupContent(ChatProvider provider) {
    switch (provider.selectedMyGroupItem) {
      case 'Recently':
      case 'Joined':
        return _buildCommunityGrid(provider);
      case 'Friend Request':
        return const SliverToBoxAdapter(child: FriendRequestList());
      case 'My Friends':
        return const SliverToBoxAdapter(child: FriendList());
      default:
        return _buildCommunityGrid(provider);
    }
  }

  Widget _buildCommunityGrid(ChatProvider provider) {
    final communities = provider.getFilteredCommunities();

    if (communities.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyStateWidget(
          title: 'No Communities Found',
          message: 'Start by exploring or creating a new community',
          icon: Icons.groups,
          onRetry: () => provider.loadCommunities(),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 4,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => CommunityGrid(communities: [communities[index]]),
        childCount: communities.length,
      ),
    );
  }
}
