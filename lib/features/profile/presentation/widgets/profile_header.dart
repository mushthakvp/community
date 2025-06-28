import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileEntity? profile;

  const ProfileHeader({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _buildProfileImage(),
          const SizedBox(width: 16),
          Expanded(child: _buildProfileInfo()),
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

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: profile?.name ?? 'User Name',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppConstants.white,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: profile?.email ?? 'user@example.com',
          fontSize: 14,
          color: AppConstants.white.withOpacity(0.7),
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppConstants.appPrimaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CommonTextWidget(
            text: profile?.tier ?? 'Basic',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppConstants.appPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.wallet,
              size: 16,
              color: AppConstants.appPrimaryColor,
            ),
            const SizedBox(width: 4),
            CommonTextWidget(
              text:
                  '${profile?.currencyCode ?? ''} ${profile?.walletAmount.toStringAsFixed(2) ?? '0.00'}',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.stars,
              size: 16,
              color: AppConstants.appPrimaryColor,
            ),
            const SizedBox(width: 4),
            CommonTextWidget(
              text: '${profile?.loyaltyPoints ?? 0} pts',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
          ],
        ),
      ],
    );
  }
}
