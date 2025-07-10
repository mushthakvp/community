import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/friend_entity.dart';
import '../../providers/chat_provider.dart';
import '../common/empty_state_widget.dart';
import 'friend_tile.dart';

class FriendList extends StatelessWidget {
  const FriendList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        final friends = provider.getFilteredFriends();

        if (friends.isEmpty) {
          return EmptyStateWidget(
            title: 'No Friends Yet',
            message: 'Start adding friends to chat with them',
            icon: Icons.people_outline,
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return FriendTile(
              friend: friend,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/single-chat',
                  arguments: {
                    'friendId': friend.id,
                    'friendName': friend.name,
                    'friendAvatar': friend.profileImage,
                  },
                );
              },
              onRemove: () =>
                  _showRemoveConfirmation(context, provider, friend),
            );
          },
        );
      },
    );
  }

  void _showRemoveConfirmation(
    BuildContext context,
    ChatProvider provider,
    FriendEntity friend,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: Text(
          'Are you sure you want to remove ${friend.name} from your friends list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.removeFriend(friend.id);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
