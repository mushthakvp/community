// features/home/presentation/widgets/loyalty_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/home_provider.dart';

class LoyaltyCard extends StatelessWidget {
  const LoyaltyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.userDetails == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                AppConstants.appPrimaryColor.withOpacity(0.9),
                AppConstants.appPrimaryColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppConstants.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(provider),
              Expanded(child: _buildCardContent(provider)),
              _buildLogo(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(HomeProvider provider) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: AppConstants.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppConstants.white.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child:
            provider.userDetails?.profileImage != null &&
                provider.userDetails!.profileImage!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: provider.userDetails!.profileImage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildLoadingAvatar(),
                errorWidget: (context, url, error) => _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildLoadingAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(35),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.black),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.black.withOpacity(0.3),
            AppConstants.black.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(35),
      ),
      child: const Icon(Icons.person, color: AppConstants.white, size: 35),
    );
  }

  Widget _buildCardContent(HomeProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Card Title
        const CommonTextWidget(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppConstants.black,
          text: "LOYALTY CARD",
          shadows: [
            Shadow(
              offset: Offset(0.0, 1.0),
              blurRadius: 2.0,
              color: Colors.black26,
            ),
            Shadow(
              offset: Offset(0.0, 2.0),
              blurRadius: 4.0,
              color: Colors.white24,
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Decorative Border
        _buildCardBorder(),

        const SizedBox(height: 12),

        // User Information
        _buildUserInfo(provider),
      ],
    );
  }

  Widget _buildCardBorder() {
    // If SVG is available, use it; otherwise, create a custom border
    return Container(
      height: 4,
      width: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.black.withOpacity(0.3),
            AppConstants.black,
            AppConstants.black.withOpacity(0.3),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: AppConstants.white.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(HomeProvider provider) {
    final userDetails = provider.userDetails!;

    return Column(
      children: [
        // First Row: Name and Loyalty Points
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _buildInfoField(
                "Name",
                userDetails.name.capitalizeFirstLetter(),
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: _buildInfoField("Points", "${userDetails.loyaltyPoints}"),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Second Row: Wallet and Community ID
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _buildInfoField(
                "Wallet",
                "${userDetails.currencyCode} ${userDetails.walletAmount.toStringAsFixed(2)}",
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: _buildInfoField(
                "ID",
                userDetails.communityId.isNotEmpty
                    ? userDetails.communityId
                    : "N/A",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppConstants.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppConstants.black.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          CommonTextWidget(
            text: label,
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: AppConstants.black.withOpacity(0.7),
          ),

          const SizedBox(height: 2),

          // Value
          CommonTextWidget(
            text: value,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppConstants.black,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppConstants.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: AppConstants.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(
          AppConstants.viveraLogo,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            decoration: BoxDecoration(
              color: AppConstants.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.business,
              color: AppConstants.black,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}

// Extension to add tier-specific styling (if needed)
extension TierStyling on LoyaltyCard {
  Color getTierColor(String? tier) {
    switch (tier?.toLowerCase()) {
      case 'sun':
        return const Color(0xFFFFD700); // Gold
      case 'moon':
        return const Color(0xFFFFCB28); // Primary yellow
      case 'star':
        return const Color(0xFFFF6B6B); // Red
      default:
        return AppConstants.appPrimaryColor;
    }
  }

  IconData getTierIcon(String? tier) {
    switch (tier?.toLowerCase()) {
      case 'sun':
        return Icons.wb_sunny;
      case 'moon':
        return Icons.nightlight_round;
      case 'star':
        return Icons.star;
      default:
        return Icons.card_membership;
    }
  }
}
