import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/home_provider.dart';

class EnhancedLoyaltyCard extends StatefulWidget {
  const EnhancedLoyaltyCard({super.key});

  @override
  State<EnhancedLoyaltyCard> createState() => _EnhancedLoyaltyCardState();
}

class _EnhancedLoyaltyCardState extends State<EnhancedLoyaltyCard>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  late Animation<double> _shimmerAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    // Start animations
    _shimmerController.repeat();
    _pulseController.repeat(reverse: true);
    _slideController.forward();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.userDetails == null) {
          return const SizedBox.shrink();
        }

        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 220,
              child: Stack(
                children: [
                  _buildMainCard(provider),
                  _buildShimmerOverlay(),
                  _buildCardContent(provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainCard(HomeProvider provider) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
            const Color(0xFF0F0F23),
          ],
        ),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.appPrimaryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerOverlay() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                AppConstants.appPrimaryColor.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: [
                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(HomeProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildCardHeader(provider),
          const SizedBox(height: 16),
          _buildAnimatedDivider(),
          const SizedBox(height: 16),
          Expanded(child: _buildStatsSection(provider)),
        ],
      ),
    );
  }

  Widget _buildCardHeader(HomeProvider provider) {
    return Row(
      children: [
        _buildProfileSection(provider),
        const Spacer(),
        _buildTitleSection(provider),
      ],
    );
  }

  Widget _buildProfileSection(HomeProvider provider) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppConstants.appPrimaryColor.withOpacity(0.8),
                AppConstants.appPrimaryColor.withOpacity(0.3),
              ],
            ),
          ),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child:
                  provider.userDetails?.profileImage != null &&
                      provider.userDetails!.profileImage!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: provider.userDetails!.profileImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildLoadingAvatar(),
                      errorWidget: (context, url, error) =>
                          _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.userDetails?.name.capitalizeFirstLetter() ?? 'User',
              style: const TextStyle(
                color: AppConstants.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getTierColor(
                  provider.userDetails?.tier,
                ).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getTierColor(
                    provider.userDetails?.tier,
                  ).withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getTierIcon(provider.userDetails?.tier),
                    size: 12,
                    color: _getTierColor(provider.userDetails?.tier),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${provider.userDetails?.tier ?? 'Member'} Tier',
                    style: TextStyle(
                      color: _getTierColor(provider.userDetails?.tier),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleSection(HomeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppConstants.appPrimaryColor.withOpacity(0.3),
                AppConstants.appPrimaryColor.withOpacity(0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              AppConstants.viveraAnim,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.diamond,
                color: AppConstants.appPrimaryColor,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.appPrimaryColor.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'LOYALTY CARD',
            style: TextStyle(
              color: AppConstants.appPrimaryColor,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedDivider() {
    return SizedBox(
      height: 2,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppConstants.appPrimaryColor.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    final delay = index * 0.3;
                    final animValue = (_shimmerController.value + delay) % 1.0;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConstants.appPrimaryColor.withOpacity(
                          0.3 + (0.7 * animValue),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.appPrimaryColor.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(HomeProvider provider) {
    final userDetails = provider.userDetails!;
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildStatCard(
                'Loyalty Points',
                '${userDetails.loyaltyPoints}',
                Icons.stars,
                AppConstants.appPrimaryColor,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Community ID',
                userDetails.communityId.isNotEmpty
                    ? userDetails.communityId
                    : 'N/A',
                Icons.group,
                Colors.blue.shade400,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              _buildStatCard(
                'Wallet Balance',
                '${userDetails.currencyCode} ${userDetails.walletAmount.toStringAsFixed(2)}',
                Icons.account_balance_wallet,
                Colors.green.shade400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: AppConstants.white.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppConstants.appPrimaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.appPrimaryColor.withOpacity(0.3),
            AppConstants.appPrimaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Icon(
        Icons.person,
        color: AppConstants.appPrimaryColor,
        size: 32,
      ),
    );
  }

  Color _getTierColor(String? tier) {
    switch (tier?.toLowerCase()) {
      case 'sun':
        return const Color(0xFFFFD700);
      case 'moon':
        return AppConstants.appPrimaryColor;
      case 'star':
        return const Color(0xFFFF6B6B);
      default:
        return AppConstants.appPrimaryColor;
    }
  }

  IconData _getTierIcon(String? tier) {
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
