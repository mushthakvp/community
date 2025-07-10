import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/friend_entity.dart';

class FriendTile extends StatelessWidget {
  final FriendEntity friend;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onRemove;
  final bool showActions;

  const FriendTile({
    super.key,
    required this.friend,
    this.onTap,
    this.onAccept,
    this.onReject,
    this.onRemove,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildFriendAvatar(),
          const SizedBox(width: 12),
          Expanded(child: _buildFriendInfo()),
          if (showActions) _buildActionButtons() else _buildChatButton(),
        ],
      ),
    );
  }

  Widget _buildFriendAvatar() {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: friend.safeProfileImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: friend.safeProfileImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFF25D366).withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: const Color(0xFF25D366),
                        size: 24,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFF25D366).withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: const Color(0xFF25D366),
                        size: 24,
                      ),
                    ),
                  )
                : Container(
                    color: const Color(0xFF25D366).withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: const Color(0xFF25D366),
                      size: 24,
                    ),
                  ),
          ),
        ),
        if (friend.isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF00FF37),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFriendInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          friend.displayName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'ID: ${friend.id}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (!friend.isOnline && friend.lastSeen != null) ...[
          const SizedBox(height: 2),
          Text(
            'Last seen ${_formatLastSeen(friend.lastSeen!)}',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onAccept != null)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              borderRadius: BorderRadius.circular(18),
            ),
            child: IconButton(
              icon: const Icon(Icons.check, color: Colors.white, size: 18),
              onPressed: onAccept,
              padding: EdgeInsets.zero,
            ),
          ),
        if (onAccept != null && onReject != null) const SizedBox(width: 8),
        if (onReject != null)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 18),
              onPressed: onReject,
              padding: EdgeInsets.zero,
            ),
          ),
        if (onRemove != null)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }

  Widget _buildChatButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF25D366),
        borderRadius: BorderRadius.circular(18),
      ),
      child: IconButton(
        icon: const Icon(Icons.chat, color: Colors.white, size: 18),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
    }
  }
}
