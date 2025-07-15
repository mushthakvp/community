import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../chat_screen/data/datasources/socket_datasource.dart';
import '../../domain/entities/community_entity.dart';
import '../providers/vchat_provider.dart';

class FriendListWidget extends StatelessWidget {
  final MyGroupFilter filter;

  const FriendListWidget({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Consumer<VChatProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.myGroups.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
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
              return _buildFriendRequestTile(context, friend, index, provider);
            } else {
              return _buildFriendTile(context, friend, provider);
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message;
    String subtitle;
    IconData icon;

    switch (filter) {
      case MyGroupFilter.friendRequest:
        message = 'No friend requests';
        subtitle = 'Friend requests will appear here';
        icon = Icons.person_add_disabled;
        break;
      case MyGroupFilter.myFriends:
        message = 'No friends yet';
        subtitle = 'Start connecting with people';
        icon = Icons.people_outline;
        break;
      case MyGroupFilter.recently:
        message = 'No recent activity';
        subtitle = 'Recent chats will appear here';
        icon = Icons.schedule;
        break;
      case MyGroupFilter.joined:
        message = 'No joined groups';
        subtitle = 'Groups you join will appear here';
        icon = Icons.group_outlined;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (filter == MyGroupFilter.myFriends)
              OutlinedButton.icon(
                onPressed: () {
                  // Navigate to find friends or invite friends
                  _showInviteFriendsOptions(context);
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Find Friends'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendTile(
    BuildContext context,
    dynamic friend,
    VChatProvider provider,
  ) {
    final friendName = _extractFriendName(friend);
    final friendImage = _extractFriendImage(friend);
    final isOnline = _extractOnlineStatus(friend);
    final lastSeen = _extractLastSeen(friend);

    return InkWell(
      onTap: () => _handleFriendTap(context, friend),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildFriendAvatar(context, friendName, friendImage, isOnline),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          friendName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildLastMessageTime(context, friend),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildOnlineStatus(context, isOnline, lastSeen),
                      const Spacer(),
                      _buildUnreadBadge(context, friend),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildFriendActions(context, friend, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRequestTile(
    BuildContext context,
    dynamic request,
    int index,
    VChatProvider provider,
  ) {
    final requestName = _extractFriendName(request);
    final requestImage = _extractFriendImage(request);
    final requestId = _extractRequestId(request);
    final isProcessing = provider.isProcessingRequest(requestId);
    final mutualFriends = _extractMutualFriends(request);
    final requestTime = _extractRequestTime(request);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFriendAvatar(context, requestName, requestImage, false),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requestName,
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
                if (mutualFriends.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${mutualFriends.length} mutual friends',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (requestTime != null)
                Text(
                  _formatRequestTime(requestTime),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 8),
              if (isProcessing)
                Container(
                  width: 120,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRequestButton(
                      context,
                      'Accept',
                      true,
                      () => _handleAcceptRequest(context, request, provider),
                    ),
                    const SizedBox(width: 8),
                    _buildRequestButton(
                      context,
                      'Reject',
                      false,
                      () => _handleRejectRequest(context, request, provider),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFriendAvatar(
    BuildContext context,
    String name,
    String? imageUrl,
    bool isOnline,
  ) {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primaryContainer,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) =>
                        _buildInitialsAvatar(context, name),
                  ),
                )
              : _buildInitialsAvatar(context, name),
        ),
        if (isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitialsAvatar(BuildContext context, String name) {
    final initials = _getInitials(name);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.primary,
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineStatus(
    BuildContext context,
    bool isOnline,
    String? lastSeen,
  ) {
    if (isOnline) {
      return Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.green),
          const SizedBox(width: 4),
          Text(
            'Online',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.green,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            lastSeen ?? 'Offline',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildLastMessageTime(BuildContext context, dynamic friend) {
    final lastMessageTime = _extractLastMessageTime(friend);
    if (lastMessageTime == null) return const SizedBox.shrink();

    return Text(
      _formatLastMessageTime(lastMessageTime),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        fontSize: 12,
      ),
    );
  }

  Widget _buildUnreadBadge(BuildContext context, dynamic friend) {
    final unreadCount = _extractUnreadCount(friend);
    if (unreadCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        unreadCount > 99 ? '99+' : unreadCount.toString(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFriendActions(
    BuildContext context,
    dynamic friend,
    VChatProvider provider,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          context,
          Icons.chat_bubble_outline,
          () => _handleChatTap(context, friend),
          Theme.of(context).colorScheme.primary,
          'Chat',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context,
          Icons.more_vert,
          () => _showFriendOptions(context, friend),
          Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          'More',
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
    Color color,
    String tooltip,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: color),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isAccept
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: !isAccept
              ? Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  width: 1,
                )
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isAccept
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Helper methods to safely extract data from friend objects
  String _extractFriendName(dynamic friend) {
    if (friend == null) return 'Unknown User';

    if (friend is CommunityEntity) {
      return friend.name;
    }

    if (friend is Map<String, dynamic>) {
      return friend['name'] ??
          friend['groupName'] ??
          friend['friendName'] ??
          friend['userName'] ??
          friend['displayName'] ??
          'Unknown User';
    }

    try {
      return _safeGetStringProperty(friend, 'name') ??
          _safeGetStringProperty(friend, 'groupName') ??
          _safeGetStringProperty(friend, 'friendName') ??
          _safeGetStringProperty(friend, 'userName') ??
          _safeGetStringProperty(friend, 'displayName') ??
          'Unknown User';
    } catch (e) {
      return 'Unknown User';
    }
  }

  String? _extractFriendImage(dynamic friend) {
    if (friend == null) return null;

    if (friend is CommunityEntity) {
      return friend.image;
    }

    if (friend is Map<String, dynamic>) {
      return friend['image'] ??
          friend['groupProfileImage'] ??
          friend['profileImage'] ??
          friend['avatar'] ??
          friend['profilePicture'];
    }

    try {
      return _safeGetStringProperty(friend, 'image') ??
          _safeGetStringProperty(friend, 'groupProfileImage') ??
          _safeGetStringProperty(friend, 'profileImage') ??
          _safeGetStringProperty(friend, 'avatar') ??
          _safeGetStringProperty(friend, 'profilePicture');
    } catch (e) {
      return null;
    }
  }

  String _extractRequestId(dynamic friend) {
    if (friend == null) return '';

    if (friend is CommunityEntity) {
      return friend.id;
    }

    if (friend is Map<String, dynamic>) {
      return friend['id'] ?? friend['_id'] ?? friend['requestId'] ?? '';
    }

    try {
      return _safeGetStringProperty(friend, 'id') ??
          _safeGetStringProperty(friend, '_id') ??
          _safeGetStringProperty(friend, 'requestId') ??
          '';
    } catch (e) {
      return '';
    }
  }

  bool _extractOnlineStatus(dynamic friend) {
    if (friend == null) return false;

    if (friend is CommunityEntity) {
      return false; // Communities don't have online status
    }

    if (friend is Map<String, dynamic>) {
      return friend['isOnline'] ?? friend['online'] ?? false;
    }

    try {
      return _safeGetBoolProperty(friend, 'isOnline') ??
          _safeGetBoolProperty(friend, 'online') ??
          false;
    } catch (e) {
      return false;
    }
  }

  String? _extractLastSeen(dynamic friend) {
    if (friend == null) return null;

    if (friend is Map<String, dynamic>) {
      final lastSeen = friend['lastSeen'] ?? friend['lastActive'];
      if (lastSeen != null) {
        try {
          final dateTime = DateTime.parse(lastSeen.toString());
          return _formatLastSeen(dateTime);
        } catch (e) {
          return null;
        }
      }
    }

    return null;
  }

  DateTime? _extractLastMessageTime(dynamic friend) {
    if (friend == null) return null;

    if (friend is Map<String, dynamic>) {
      final lastMessageTime = friend['lastMessageTime'] ?? friend['updatedAt'];
      if (lastMessageTime != null) {
        try {
          return DateTime.parse(lastMessageTime.toString());
        } catch (e) {
          return null;
        }
      }
    }

    return null;
  }

  int _extractUnreadCount(dynamic friend) {
    if (friend == null) return 0;

    if (friend is Map<String, dynamic>) {
      return friend['unreadCount'] ?? friend['unreadMessages'] ?? 0;
    }

    return 0;
  }

  List<String> _extractMutualFriends(dynamic friend) {
    if (friend == null) return [];

    if (friend is Map<String, dynamic>) {
      final mutualFriends = friend['mutualFriends'] as List<dynamic>?;
      return mutualFriends?.map((e) => e.toString()).toList() ?? [];
    }

    return [];
  }

  DateTime? _extractRequestTime(dynamic friend) {
    if (friend == null) return null;

    if (friend is Map<String, dynamic>) {
      final requestTime = friend['requestTime'] ?? friend['createdAt'];
      if (requestTime != null) {
        try {
          return DateTime.parse(requestTime.toString());
        } catch (e) {
          return null;
        }
      }
    }

    return null;
  }

  String? _safeGetStringProperty(dynamic object, String propertyName) {
    try {
      switch (propertyName) {
        case 'name':
          return object.name as String?;
        case 'groupName':
          return object.groupName as String?;
        case 'friendName':
          return object.friendName as String?;
        case 'userName':
          return object.userName as String?;
        case 'displayName':
          return object.displayName as String?;
        case 'image':
          return object.image as String?;
        case 'groupProfileImage':
          return object.groupProfileImage as String?;
        case 'profileImage':
          return object.profileImage as String?;
        case 'avatar':
          return object.avatar as String?;
        case 'profilePicture':
          return object.profilePicture as String?;
        case 'id':
          return object.id as String?;
        case '_id':
          return object._id as String?;
        case 'requestId':
          return object.requestId as String?;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  bool? _safeGetBoolProperty(dynamic object, String propertyName) {
    try {
      switch (propertyName) {
        case 'isOnline':
          return object.isOnline as bool?;
        case 'online':
          return object.online as bool?;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
    }
  }

  String _formatLastMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  String _formatRequestTime(DateTime requestTime) {
    final now = DateTime.now();
    final difference = now.difference(requestTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  void _handleFriendTap(BuildContext context, dynamic friend) {
    // Navigate to personal chat
    _navigateToPersonalChat(context, friend);
  }

  void _handleChatTap(BuildContext context, dynamic friend) {
    // Navigate to personal chat
    _navigateToPersonalChat(context, friend);
  }

  void _navigateToPersonalChat(BuildContext context, dynamic friend) {
    final friendId = _extractRequestId(friend);
    final friendName = _extractFriendName(friend);
    final friendImage = _extractFriendImage(friend);

    if (friendId.isNotEmpty) {
      final route =
          '/chat/$friendId?t=${DateTime.now().millisecondsSinceEpoch}';

      context.push(
        route,
        extra: {
          'chatName': friendName,
          'chatImage': friendImage,
          'isGroup': false,
          'isPersonalChat': true,
          'chatType': ChatType.personal,
          'friendId': friendId,
        },
      );
    }
  }

  void _handleAcceptRequest(
    BuildContext context,
    dynamic request,
    VChatProvider provider,
  ) {
    final requestId = _extractRequestId(request);
    final requestName = _extractFriendName(request);

    if (requestId.isNotEmpty) {
      provider
          .acceptFriendRequestById(requestId)
          .then((_) {
            // Show success message
            if (provider.error == null) {
              _showSuccessSnackBar(
                context,
                'Accepted friend request from $requestName',
                Colors.green,
                Icons.check_circle,
              );
            } else {
              _showErrorSnackBar(context, provider.error!);
            }
          })
          .catchError((error) {
            _showErrorSnackBar(context, 'Failed to accept friend request');
          });
    }
  }

  void _handleRejectRequest(
    BuildContext context,
    dynamic request,
    VChatProvider provider,
  ) {
    final requestId = _extractRequestId(request);
    final requestName = _extractFriendName(request);

    if (requestId.isNotEmpty) {
      provider
          .rejectFriendRequestById(requestId)
          .then((_) {
            // Show success message
            if (provider.error == null) {
              _showSuccessSnackBar(
                context,
                'Rejected friend request from $requestName',
                Colors.orange,
                Icons.cancel,
              );
            } else {
              _showErrorSnackBar(context, provider.error!);
            }
          })
          .catchError((error) {
            _showErrorSnackBar(context, 'Failed to reject friend request');
          });
    }
  }

  void _showSuccessSnackBar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showFriendOptions(BuildContext context, dynamic friend) {
    final friendName = _extractFriendName(friend);
    final friendImage = _extractFriendImage(friend);
    final isOnline = _extractOnlineStatus(friend);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFriendAvatar(
                    context,
                    friendName,
                    friendImage,
                    isOnline,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friendName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        _buildOnlineStatus(
                          context,
                          isOnline,
                          _extractLastSeen(friend),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionTile(
              context,
              icon: Icons.chat_bubble_outline,
              title: 'Start Chat',
              subtitle: 'Send a message',
              onTap: () {
                Navigator.pop(context);
                _handleChatTap(context, friend);
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.videocam_outlined,
              title: 'Video Call',
              subtitle: 'Start a video call',
              onTap: () {
                Navigator.pop(context);
                _handleVideoCall(context, friend);
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.call_outlined,
              title: 'Voice Call',
              subtitle: 'Start a voice call',
              onTap: () {
                Navigator.pop(context);
                _handleVoiceCall(context, friend);
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.info_outline,
              title: 'View Profile',
              subtitle: 'See profile details',
              onTap: () {
                Navigator.pop(context);
                _handleViewProfile(context, friend);
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.block,
              title: 'Block User',
              subtitle: 'Block this person',
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation(context, friend);
              },
              isDestructive: true,
            ),
            _buildOptionTile(
              context,
              icon: Icons.person_remove,
              title: 'Remove Friend',
              subtitle: 'Remove from friends list',
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
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDestructive
              ? Theme.of(context).colorScheme.error.withOpacity(0.7)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          fontSize: 12,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showRemoveFriendDialog(BuildContext context, dynamic friend) {
    final friendName = _extractFriendName(friend);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.person_remove,
          color: Theme.of(context).colorScheme.error,
          size: 32,
        ),
        title: const Text('Remove Friend'),
        content: Text(
          'Are you sure you want to remove $friendName from your friends list? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _handleRemoveFriend(context, friend);
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

  void _showBlockConfirmation(BuildContext context, dynamic friend) {
    final friendName = _extractFriendName(friend);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.block,
          color: Theme.of(context).colorScheme.error,
          size: 32,
        ),
        title: const Text('Block User'),
        content: Text(
          'Are you sure you want to block $friendName? They will no longer be able to send you messages or see your profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _handleBlockUser(context, friend);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }

  void _showInviteFriendsOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Find Friends',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              context,
              icon: Icons.search,
              title: 'Search by Username',
              subtitle: 'Find friends by their username',
              onTap: () {
                Navigator.pop(context);
                // Navigate to search friends page
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.contacts,
              title: 'Sync Contacts',
              subtitle: 'Find friends from your contacts',
              onTap: () {
                Navigator.pop(context);
                // Handle contact sync
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.share,
              title: 'Invite Friends',
              subtitle: 'Share your profile with others',
              onTap: () {
                Navigator.pop(context);
                // Handle invite sharing
              },
            ),
            _buildOptionTile(
              context,
              icon: Icons.qr_code,
              title: 'QR Code',
              subtitle: 'Share your QR code',
              onTap: () {
                Navigator.pop(context);
                // Show QR code
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleVideoCall(BuildContext context, dynamic friend) {
    final friendName = _extractFriendName(friend);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting video call with $friendName...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleVoiceCall(BuildContext context, dynamic friend) {
    final friendName = _extractFriendName(friend);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting voice call with $friendName...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleViewProfile(BuildContext context, dynamic friend) {
    final friendId = _extractRequestId(friend);
    if (friendId.isNotEmpty) {
      context.push('/profile/$friendId');
    } else {
      _showErrorSnackBar(context, 'Unable to view profile');
    }
  }

  void _handleRemoveFriend(BuildContext context, dynamic friend) {
    final friendName = _extractFriendName(friend);
    _showSuccessSnackBar(
      context,
      'Removed $friendName from your friends',
      Colors.orange,
      Icons.person_remove,
    );
  }

  void _handleBlockUser(BuildContext context, dynamic friend) {
    final friendName = _extractFriendName(friend);
    _showSuccessSnackBar(
      context,
      'Blocked $friendName',
      Colors.red,
      Icons.block,
    );
  }
}
