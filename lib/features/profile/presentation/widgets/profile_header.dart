import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileEntity? profile;

  const ProfileHeader({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Profile Image and Basic Info
          Row(
            children: [
              _buildProfileImage(),
              const SizedBox(width: 16),
              Expanded(child: _buildBasicInfo()),
            ],
          ),

          const SizedBox(height: 20),

          // Stats Row
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 38,
        backgroundColor: AppConstants.appPrimaryColor,
        backgroundImage: profile?.profileImage.isNotEmpty == true
            ? NetworkImage(profile!.profileImage)
            : null,
        child: profile?.profileImage.isEmpty != false
            ? const Icon(Icons.person, color: AppConstants.black, size: 40)
            : null,
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: profile?.name ?? 'Loading...',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
          maxLines: 2,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: profile?.email ?? 'Loading...',
          fontSize: 15,
          color: const Color(0xFF8E8E93),
          maxLines: 1,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CommonTextWidget(
                text: '${profile?.tier ?? 'Basic'} Member',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ),
            const SizedBox(width: 8),
            if (profile?.joinedDate != null)
              CommonTextWidget(
                text:
                    'Since ${DateFormat('MMM yyyy').format(profile!.joinedDate)}',
                fontSize: 12,
                color: const Color(0xFF8E8E93),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.wallet,
              label: 'Wallet Balance',
              value:
                  '${profile?.currencyCode ?? 'INR'} ${profile?.walletAmount.toStringAsFixed(2) ?? '0.00'}',
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0xFF3A3A3C)),
          Expanded(
            child: _buildStatItem(
              icon: Icons.stars,
              label: 'Loyalty Points',
              value: '${profile?.loyaltyPoints ?? 0}',
            ),
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
        Icon(icon, color: AppConstants.appPrimaryColor, size: 24),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 2),
        CommonTextWidget(
          text: label,
          fontSize: 12,
          color: const Color(0xFF8E8E93),
          align: TextAlign.center,
        ),
      ],
    );
  }
}
