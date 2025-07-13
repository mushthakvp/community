import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/community_entity.dart';

class CommunityTileWidget extends StatelessWidget {
  final CommunityEntity community;
  final VoidCallback? onTap;
  final bool showJoinButton;
  final bool showMemberCount;

  const CommunityTileWidget({
    super.key,
    required this.community,
    this.onTap,
    this.showJoinButton = true,
    this.showMemberCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => _handleTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildCommunityAvatar(context),
            const SizedBox(width: 12),
            Expanded(child: _buildCommunityInfo(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityAvatar(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: community.image != null && community.image!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                community.image!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(context),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingAvatar(context);
                },
              ),
            )
          : _buildDefaultAvatar(context),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return Icon(
      Icons.groups,
      size: 28,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  Widget _buildLoadingAvatar(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildCommunityInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Community name and status badges row
        Row(
          children: [
            Expanded(
              child: Text(
                community.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),

            // Status badges
            if (community.isCreated)
              _buildStatusChip(
                context,
                'Admin',
                Theme.of(context).colorScheme.primary,
              )
            else if (community.isJoined)
              _buildStatusChip(
                context,
                'Member',
                Theme.of(context).colorScheme.tertiary,
              ),
          ],
        ),
        const SizedBox(height: 4),

        // Member count and member avatars row
        Row(
          children: [
            if (showMemberCount) ...[
              Icon(
                Icons.people,
                size: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                _formatMemberCount(community.memberCount),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
            ],

            // Member avatars preview
            if (community.profileImages.isNotEmpty) ...[
              const SizedBox(width: 12),
              _buildMemberAvatars(context),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildMemberAvatars(BuildContext context) {
    final displayCount = community.profileImages.length > 3
        ? 3
        : community.profileImages.length;
    final hasMore = community.profileImages.length > 3;

    // Calculate total width needed
    final totalAvatars = hasMore ? displayCount + 1 : displayCount;
    final totalWidth =
        (totalAvatars * 14.0) + 6.0; // 14px spacing + 6px for last avatar

    return SizedBox(
      height: 20,
      width: totalWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Member avatars
          ...List.generate(displayCount, (index) {
            return Positioned(
              left: index * 14.0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  backgroundImage: community.profileImages[index].isNotEmpty
                      ? NetworkImage(community.profileImages[index])
                      : null,
                  child: community.profileImages[index].isEmpty
                      ? Icon(
                          Icons.person,
                          size: 10,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        )
                      : null,
                ),
              ),
            );
          }),

          // "+X more" indicator
          if (hasMore)
            Positioned(
              left: displayCount * 14.0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+${community.profileImages.length - displayCount}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatMemberCount(int count) {
    if (count < 1000) {
      return '$count';
    } else if (count < 1000000) {
      final k = (count / 1000).toStringAsFixed(1);
      return '${k}K';
    } else {
      final m = (count / 1000000).toStringAsFixed(1);
      return '${m}M';
    }
  }

  void _handleTap(BuildContext context) {
    final route =
        '/chat/${community.id}?t=${DateTime.now().millisecondsSinceEpoch}';

    debugPrint('Navigating to community chat: ${community.id}');

    context.push(
      route,
      extra: {
        'chatName': community.name,
        'chatImage': community.image,
        'isGroup': true,
        'communityId': community.id,
      },
    );
  }
}
