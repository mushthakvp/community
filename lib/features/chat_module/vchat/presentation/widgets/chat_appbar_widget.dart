import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/constants/app_constants.dart';
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
          colors: [AppConstants.appPrimaryColor, AppConstants.black],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Chat',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Row(children: [_buildTabSelector(context)]),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
