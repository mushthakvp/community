import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/community_entity.dart';

class CommunityTile extends StatelessWidget {
  final CommunityEntity community;
  final VoidCallback? onTap;
  final bool showMembers;

  const CommunityTile({
    super.key,
    required this.community,
    this.onTap,
    this.showMembers = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            _buildCommunityAvatar(),
            const SizedBox(width: 12),
            Expanded(child: _buildCommunityInfo()),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityAvatar() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: community.safeProfileImage.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: community.safeProfileImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFF25D366).withOpacity(0.1),
                  child: const Icon(
                    Icons.group,
                    color: Color(0xFF25D366),
                    size: 24,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF25D366).withOpacity(0.1),
                  child: const Icon(
                    Icons.group,
                    color: Color(0xFF25D366),
                    size: 24,
                  ),
                ),
              )
            : Container(
                color: const Color(0xFF25D366).withOpacity(0.1),
                child: const Icon(
                  Icons.group,
                  color: Color(0xFF25D366),
                  size: 24,
                ),
              ),
      ),
    );
  }

  Widget _buildCommunityInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          community.displayName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        if (community.description != null && community.description!.isNotEmpty)
          Text(
            community.description!,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (showMembers) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              if (community.profileImages.isNotEmpty)
                SizedBox(
                  width: 80,
                  height: 20,
                  child: Stack(
                    children: List.generate(
                      community.profileImages.length > 4
                          ? 4
                          : community.profileImages.length,
                      (index) => Positioned(
                        left: index * 15.0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(
                            community.profileImages[index],
                          ),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                '${community.memberCount} members',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF25D366),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
    );
  }
}
