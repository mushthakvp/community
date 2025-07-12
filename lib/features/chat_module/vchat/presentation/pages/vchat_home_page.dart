import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/shimmer_widgets.dart';
import '../providers/vchat_provider.dart';
import '../widgets/chat_appbar_widget.dart';
import '../widgets/chat_banner_widgets.dart';
import '../widgets/community_tile_widget.dart';
import '../widgets/friend_list_widgets.dart';

class VChatHomePage extends StatefulWidget {
  const VChatHomePage({super.key});

  @override
  State<VChatHomePage> createState() => _VChatHomePageState();
}

class _VChatHomePageState extends State<VChatHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VChatProvider>().fetchRecommendedCommunities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ChatAppBarWidget(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<VChatProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerSection(provider),
                  const SizedBox(height: 24),
                  _buildContentSection(provider),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection(VChatProvider provider) {
    switch (provider.selectedTab) {
      case VChatTab.explore:
        return const ExploreBanner();
      case VChatTab.popular:
        return const PopularBanner();
      case VChatTab.myGroup:
        return const MyGroupBanner();
    }
  }

  Widget _buildContentSection(VChatProvider provider) {
    if (provider.selectedTab == VChatTab.myGroup) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter tabs for My Group
          _buildFilterTabs(provider),
          const SizedBox(height: 16),
          // Content based on filter
          _buildMyGroupContent(provider),
        ],
      );
    } else {
      return _buildCommunitiesContent(provider);
    }
  }

  Widget _buildFilterTabs(VChatProvider provider) {
    final filters = [
      MyGroupFilter.recently,
      MyGroupFilter.joined,
      MyGroupFilter.friendRequest,
      MyGroupFilter.myFriends,
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = provider.selectedFilter == filter;

          return GestureDetector(
            onTap: () => provider.changeFilter(filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Text(
                _getFilterLabel(filter),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyGroupContent(VChatProvider provider) {
    if (provider.selectedFilter == MyGroupFilter.friendRequest ||
        provider.selectedFilter == MyGroupFilter.myFriends) {
      return FriendListWidget(filter: provider.selectedFilter);
    }

    return _buildCommunitiesList(provider.myGroups, provider.isLoading);
  }

  Widget _buildCommunitiesContent(VChatProvider provider) {
    return _buildCommunitiesList(provider.communities, provider.isLoading);
  }

  Widget _buildCommunitiesList(List<dynamic> communities, bool isLoading) {
    if (isLoading && communities.isEmpty) {
      return const ChatShimmerWidget();
    }

    if (communities.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.groups_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No communities found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try exploring different categories',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: communities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final community = communities[index];
        return CommunityTileWidget(community: community);
      },
    );
  }

  String _getFilterLabel(MyGroupFilter filter) {
    switch (filter) {
      case MyGroupFilter.recently:
        return 'Recently';
      case MyGroupFilter.joined:
        return 'Joined';
      case MyGroupFilter.friendRequest:
        return 'Friend Requests';
      case MyGroupFilter.myFriends:
        return 'My Friends';
    }
  }
}
