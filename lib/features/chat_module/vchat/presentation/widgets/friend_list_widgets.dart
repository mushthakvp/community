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
          separatorBuilder: (_, __) => const Divider(),
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
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundImage: friend.image != null
            ? NetworkImage(friend.image!)
            : null,
        child: friend.image == null
            ? Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )
            : null,
      ),
      title: Text(
        friend.name ?? 'Unknown',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'ID: ${friend.id}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              // Navigate to chat
            },
            icon: const Icon(Icons.chat_bubble_outline),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              _showRemoveFriendDialog(context, friend);
            },
            icon: const Icon(Icons.person_remove),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendRequestTile(
    BuildContext context,
    dynamic request,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage: request.image != null
                  ? NetworkImage(request.image!)
                  : null,
              child: request.image == null
                  ? Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.name ?? 'Unknown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Wants to connect with you',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(60, 32),
                  ),
                  child: const Text('Accept'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    minimumSize: const Size(60, 32),
                  ),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
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
