import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/community_entity.dart';
import '../providers/vchat_provider.dart';

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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap ?? () => _handleTap(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Community avatar
              _buildCommunityAvatar(context),
              const SizedBox(width: 16),

              // Community info
              Expanded(child: _buildCommunityInfo(context)),

              // Action button
              if (showJoinButton) _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityAvatar(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: community.image != null && community.image!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                community.image!,
                width: 60,
                height: 60,
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
      size: 30,
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
        // Community name
        Text(
          community.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Member count and status
        Row(
          children: [
            if (showMemberCount) ...[
              Icon(
                Icons.people,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                _formatMemberCount(community.memberCount),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],

            // Community status badges
            if (community.isCreated) ...[
              const SizedBox(width: 8),
              _buildStatusChip(
                context,
                'Created',
                Theme.of(context).colorScheme.primary,
              ),
            ] else if (community.isJoined) ...[
              const SizedBox(width: 8),
              _buildStatusChip(
                context,
                'Joined',
                Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ],
        ),

        // Member avatars preview
        if (community.profileImages.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildMemberAvatars(context),
        ],
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
    final displayCount = community.profileImages.length > 4
        ? 4
        : community.profileImages.length;
    final hasMore = community.profileImages.length > 4;

    return SizedBox(
      height: 24,
      child: Stack(
        children: [
          // Member avatars
          ...List.generate(displayCount, (index) {
            return Positioned(
              left: index * 18.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  backgroundImage: community.profileImages[index].isNotEmpty
                      ? NetworkImage(community.profileImages[index])
                      : null,
                  child: community.profileImages[index].isEmpty
                      ? Icon(
                          Icons.person,
                          size: 12,
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
              left: displayCount * 18.0,
              child: Container(
                width: 24,
                height: 24,
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
                      fontSize: 8,
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

  Widget _buildActionButton(BuildContext context) {
    return Consumer<VChatProvider>(
      builder: (context, provider, _) {
        if (community.isJoined || community.isCreated) {
          return _buildEnterButton(context);
        } else {
          return _buildJoinButton(context, provider);
        }
      },
    );
  }

  Widget _buildEnterButton(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.onPrimary,
        size: 20,
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context, VChatProvider provider) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        size: 20,
      ),
    );
  }

  String _formatMemberCount(int count) {
    if (count < 1000) {
      return '$count member${count == 1 ? '' : 's'}';
    } else if (count < 1000000) {
      final k = (count / 1000).toStringAsFixed(1);
      return '${k}K members';
    } else {
      final m = (count / 1000000).toStringAsFixed(1);
      return '${m}M members';
    }
  }

  void _handleTap(BuildContext context) {
    // Navigate to chat screen
    context.push(
      '/chat/${community.id}',
      extra: {
        'chatName': community.name,
        'chatImage': community.image,
        'isGroup': true,
      },
    );
  }
}

// Compact version for horizontal lists
class CompactCommunityTile extends StatelessWidget {
  final CommunityEntity community;
  final VoidCallback? onTap;

  const CompactCommunityTile({super.key, required this.community, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap ?? () => _handleTap(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Community avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child:
                          community.image != null && community.image!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                community.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.groups,
                                      size: 25,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                            )
                          : Icon(
                              Icons.groups,
                              size: 25,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                    ),
                    const SizedBox(width: 12),

                    // Community info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            community.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${community.id}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Action button
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        community.isJoined ? Icons.arrow_forward : Icons.add,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Member count and avatars
                Row(
                  children: [
                    // Member avatars
                    if (community.profileImages.isNotEmpty)
                      SizedBox(
                        height: 20,
                        width: 60,
                        child: Stack(
                          children: List.generate(
                            community.profileImages.length > 3
                                ? 3
                                : community.profileImages.length,
                            (index) => Positioned(
                              left: index * 15.0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    width: 1,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 9,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                                  backgroundImage:
                                      community.profileImages[index].isNotEmpty
                                      ? NetworkImage(
                                          community.profileImages[index],
                                        )
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
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),

                    // Member count
                    Text(
                      '${community.memberCount} members',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    context.push(
      '/chat/${community.id}',
      extra: {
        'chatName': community.name,
        'chatImage': community.image,
        'isGroup': true,
      },
    );
  }
}
