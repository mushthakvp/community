import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vchat_provider.dart';

class FriendListWidget extends StatelessWidget {
  final MyGroupFilter filter;

  const FriendListWidget({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Consumer<VChatProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.myGroups.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.myGroups.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.myGroups.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
          itemBuilder: (context, index) {
            final friend = provider.myGroups[index];

            if (filter == MyGroupFilter.friendRequest) {
              return _buildFriendRequestTile(context, friend, index);
            } else {
              return _buildFriendTile(context, friend);
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message;
    IconData icon;

    switch (filter) {
      case MyGroupFilter.friendRequest:
        message = 'No friend requests';
        icon = Icons.person_add_disabled;
        break;
      case MyGroupFilter.myFriends:
        message = 'No friends yet';
        icon = Icons.people_outline;
        break;
      default:
        message = 'Nothing to show';
        icon = Icons.inbox_outlined;
    }

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendTile(BuildContext context, dynamic friend) {
    return InkWell(
      onTap: () => _handleFriendTap(context, friend),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Friend avatar
            _buildFriendAvatar(context, friend),
            const SizedBox(width: 12),

            // Friend info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name ?? 'Unknown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        'Online',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action section
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getTimeString(friend),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                // Action buttons in a row
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.chat_bubble_outline,
                      () => _handleChatTap(context, friend),
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      context,
                      Icons.more_vert,
                      () => _showFriendOptions(context, friend),
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRequestTile(
    BuildContext context,
    dynamic request,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Request avatar
          _buildFriendAvatar(context, request),
          const SizedBox(width: 12),

          // Request info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.name ?? 'Unknown',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Wants to connect with you',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Action section for friend requests
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Now',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRequestButton(
                    context,
                    'Accept',
                    true,
                    () => _handleAcceptRequest(context, request),
                  ),
                  const SizedBox(width: 8),
                  _buildRequestButton(
                    context,
                    'Reject',
                    false,
                    () => _handleRejectRequest(context, request),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFriendAvatar(BuildContext context, dynamic friend) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: friend.image != null && friend.image!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                friend.image!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  size: 28,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            )
          : Icon(
              Icons.person,
              size: 28,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildRequestButton(
    BuildContext context,
    String label,
    bool isAccept,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isAccept
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
          border: !isAccept
              ? Border.all(color: Theme.of(context).colorScheme.error, width: 1)
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isAccept
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  String _getTimeString(dynamic friend) {
    // Placeholder time - you can implement actual timestamp logic
    final times = ['9:30 AM', '10:15 AM', '11:45 AM', '2:20 PM', 'Yesterday'];
    return times[friend.name.hashCode % times.length];
  }

  void _handleFriendTap(BuildContext context, dynamic friend) {
    // Navigate to personal chat
    // context.push('/chat/${friend.id}');
  }

  void _handleChatTap(BuildContext context, dynamic friend) {
    // Navigate to chat with friend
    // context.push('/chat/${friend.id}');
  }

  void _handleAcceptRequest(BuildContext context, dynamic request) {
    // Handle accept friend request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted friend request from ${request.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleRejectRequest(BuildContext context, dynamic request) {
    // Handle reject friend request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected friend request from ${request.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFriendOptions(BuildContext context, dynamic friend) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Options
            _buildOptionTile(
              context,
              icon: Icons.chat_bubble_outline,
              title: 'Start Chat',
              onTap: () {
                Navigator.pop(context);
                _handleChatTap(context, friend);
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.info_outline,
              title: 'View Profile',
              onTap: () {
                Navigator.pop(context);
                // Handle view profile
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.person_remove,
              title: 'Remove Friend',
              onTap: () {
                Navigator.pop(context);
                _showRemoveFriendDialog(context, friend);
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showRemoveFriendDialog(BuildContext context, dynamic friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text(
          'Are you sure you want to remove ${friend.name} from your friends?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle remove friend logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${friend.name} from friends'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
