import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../common/empty_state_widget.dart';
import 'friend_tile.dart';

class FriendRequestList extends StatelessWidget {
  const FriendRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        final requests = provider.friendRequests;

        if (requests.isEmpty) {
          return EmptyStateWidget(
            title: 'No Friend Requests',
            message: 'You have no pending friend requests',
            icon: Icons.person_add_outlined,
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return FriendTile(
              friend: request,
              showActions: true,
              onAccept: () => provider.acceptFriendRequest(request.id),
              onReject: () => provider.rejectFriendRequest(request.id),
            );
          },
        );
      },
    );
  }
}
