import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/community_info_entity.dart';

class ProfileHeader extends StatelessWidget {
  final CommunityInfoEntity communityInfo;
  final int memberCount;

  const ProfileHeader({
    super.key,
    required this.communityInfo,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Community Image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: AppConstants.primary.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primary.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: communityInfo.image?.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: communityInfo.image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppConstants.primary,
                            AppConstants.primary.withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.group,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // Community Name
          Text(
            communityInfo.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Community ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[800]?.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'ID: ${communityInfo.communityId}',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Stats Row - Removed Status, kept Members and Role
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.group,
                label: 'Members',
                value: memberCount.toString(),
              ),
              Container(width: 1, height: 40, color: Colors.grey[600]),
              _buildStatItem(
                icon: communityInfo.isCreator
                    ? Icons.admin_panel_settings
                    : Icons.person,
                label: communityInfo.isCreator ? 'Creator' : 'Member',
                value: communityInfo.isCreator ? 'Admin' : 'User',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }
}
