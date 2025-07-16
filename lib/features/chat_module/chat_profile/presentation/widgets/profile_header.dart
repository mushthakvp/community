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
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 60, // Reduced top padding
        bottom: 10, // Reduced bottom padding
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Important: minimize space usage
        children: [
          // Community Image - smaller size
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: AppConstants.primary.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primary.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: communityInfo.image?.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: communityInfo.image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.group,
                          color: Colors.white,
                          size: 30,
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
                        size: 30,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 12),

          // Community Name - smaller font
          Text(
            communityInfo.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // Community ID - smaller
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[800]?.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'ID: ${communityInfo.communityId}',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Stats Row - more compact
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.group,
                label: 'Members',
                value: memberCount.toString(),
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey[600],
                margin: const EdgeInsets.symmetric(horizontal: 15),
              ),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppConstants.primary, size: 18),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
      ],
    );
  }
}
