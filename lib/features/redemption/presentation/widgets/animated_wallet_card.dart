import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/spacer_widget.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/shimmer_loading.dart';
import '../providers/redemption_provider.dart';

class AnimatedWalletCard extends StatefulWidget {
  const AnimatedWalletCard({super.key});

  @override
  State<AnimatedWalletCard> createState() => _AnimatedWalletCardState();
}

class _AnimatedWalletCardState extends State<AnimatedWalletCard>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _glowController;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _shimmerController.repeat();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RedemptionProvider>(
      builder: (context, provider, child) {
        return ShimmerLoading(
          isLoading: provider.isLoadingUserDetails,
          child: AnimatedBuilder(
            animation: Listenable.merge([_shimmerAnimation, _glowAnimation]),
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFF2A2A2A),
                        AppConstants.appPrimaryColor.withOpacity(0.3),
                        _glowAnimation.value * 0.2,
                      )!,
                      Color.lerp(
                        const Color(0xFF1A1A1A),
                        AppConstants.appPrimaryColor.withOpacity(0.2),
                        _glowAnimation.value * 0.1,
                      )!,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.appPrimaryColor.withOpacity(
                        0.2 * _glowAnimation.value,
                      ),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Shimmer effect overlay
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.transparent,
                                    AppConstants.appPrimaryColor.withOpacity(
                                      0.1,
                                    ),
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, _shimmerAnimation.value, 1.0],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Card content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: _buildCardContent(provider),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCardContent(RedemptionProvider provider) {
    final user = provider.userDetails;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonTextWidget(
              text: 'Wallet Balance',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppConstants.appPrimaryColor.withOpacity(0.5),
                ),
              ),
              child: CommonTextWidget(
                text: user?.tier ?? 'Standard',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ),
          ],
        ),
        AppSpacing.verticalLG,
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1500),
          tween: Tween(begin: 0.0, end: user?.walletAmount ?? 0.0),
          builder: (context, value, child) {
            return CommonTextWidget(
              text: '${user?.currencyCode ?? '₹'} ${value.toStringAsFixed(2)}',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppConstants.appPrimaryColor,
            );
          },
        ),
        AppSpacing.verticalSM,
        Row(
          children: [
            _buildFeatureIcon(Icons.security, 'Secure'),
            AppSpacing.horizontalMD,
            _buildFeatureIcon(Icons.flash_on, 'Instant'),
            AppSpacing.horizontalMD,
            _buildFeatureIcon(Icons.verified, 'Verified'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppConstants.appPrimaryColor.withOpacity(0.6),
          size: 16,
        ),
        AppSpacing.horizontalXS,
        CommonTextWidget(
          text: label,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ],
    );
  }
}
