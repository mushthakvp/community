import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/vchat_provider.dart';

class ChatAppBarWidget extends StatelessWidget {
  const ChatAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Main app bar row
              Row(
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title
                  Text(
                    'Chat',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),

                  // Tab selector and actions
                  Row(
                    children: [
                      _buildTabSelector(context),
                      const SizedBox(width: 12),
                      _buildPersonalChatButton(context),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector(BuildContext context) {
    return Consumer<VChatProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
            ),
          ),
          child: DropdownButton<VChatTab>(
            value: provider.selectedTab,
            underline: const SizedBox(),
            dropdownColor: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            items: VChatTab.values.map((tab) {
              return DropdownMenuItem(
                value: tab,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getTabIcon(tab),
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getTabLabel(tab),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (tab) {
              if (tab != null) {
                provider.changeTab(tab);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildPersonalChatButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Navigate to personal chat list
        context.push('/personal-chat');
      },
      icon: Icon(
        Icons.chat_bubble_outline,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.onPrimary.withOpacity(0.15),
        padding: const EdgeInsets.all(12),
      ),
      tooltip: 'Personal Chats',
    );
  }

  IconData _getTabIcon(VChatTab tab) {
    switch (tab) {
      case VChatTab.explore:
        return Icons.explore;
      case VChatTab.popular:
        return Icons.trending_up;
      case VChatTab.myGroup:
        return Icons.groups;
    }
  }

  String _getTabLabel(VChatTab tab) {
    switch (tab) {
      case VChatTab.explore:
        return 'Explore';
      case VChatTab.popular:
        return 'Popular';
      case VChatTab.myGroup:
        return 'My Groups';
    }
  }
}

class CompactChatAppBar extends StatelessWidget {
  const CompactChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                'Communities',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Consumer<VChatProvider>(
                builder: (context, provider, _) {
                  return SegmentedButton<VChatTab>(
                    segments: VChatTab.values.map((tab) {
                      return ButtonSegment<VChatTab>(
                        value: tab,
                        label: Text(
                          _getTabLabel(tab),
                          style: const TextStyle(fontSize: 12),
                        ),
                        icon: Icon(_getTabIcon(tab), size: 16),
                      );
                    }).toList(),
                    selected: {provider.selectedTab},
                    onSelectionChanged: (Set<VChatTab> selection) {
                      if (selection.isNotEmpty) {
                        provider.changeTab(selection.first);
                      }
                    },
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.1),
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      selectedBackgroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                      selectedForegroundColor: Theme.of(
                        context,
                      ).colorScheme.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTabIcon(VChatTab tab) {
    switch (tab) {
      case VChatTab.explore:
        return Icons.explore;
      case VChatTab.popular:
        return Icons.trending_up;
      case VChatTab.myGroup:
        return Icons.groups;
    }
  }

  String _getTabLabel(VChatTab tab) {
    switch (tab) {
      case VChatTab.explore:
        return 'Explore';
      case VChatTab.popular:
        return 'Popular';
      case VChatTab.myGroup:
        return 'My Groups';
    }
  }
}
