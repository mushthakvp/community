import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../../../../core/constants/app_constants.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background GIF - Full screen (same as home page)
          Positioned.fill(
            child: Image.asset(
              'assets/animation/bg.gif',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to gradient if GIF fails to load
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0A0A0A),
                        Color(0xFF1A1A2E),
                        Color(0xFF0F0F23),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Semi-transparent overlay for better shimmer visibility
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.5),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Shimmer content
          Column(
            children: [
              // Sticky App Bar Shimmer
              _buildStickyAppBarShimmer(),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildLoyaltyCardShimmer(context),
                      const SizedBox(height: 24),
                      _buildMarqueeShimmer(context),
                      const SizedBox(height: 24),
                      _buildBannerShimmer(context),
                      const SizedBox(height: 32),
                      _buildSpinGamesShimmer(context),
                      const SizedBox(height: 32),
                      _buildEssentialsShimmer(context),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyAppBarShimmer() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A0A0A).withOpacity(0.8),
            const Color(0xFF1A1A2E).withOpacity(0.7),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildShimmerContainer(80, 18),
                      const SizedBox(height: 4),
                      _buildShimmerContainer(120, 13),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _buildShimmerContainer(40, 40, borderRadius: 12),
                  const SizedBox(width: 8),
                  _buildShimmerContainer(40, 40, borderRadius: 12),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoyaltyCardShimmer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E).withOpacity(0.8),
            const Color(0xFF16213E).withOpacity(0.8),
            const Color(0xFF0F0F23).withOpacity(0.8),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Header section
            Row(
              children: [
                // Profile section
                Row(
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
                      child: _buildShimmerContainer(64, 64, isCircle: true),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerContainer(100, 16),
                        const SizedBox(height: 4),
                        _buildShimmerContainer(80, 12, borderRadius: 12),
                        const SizedBox(height: 6),
                        _buildShimmerContainer(90, 13),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                // Title section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildShimmerContainer(48, 48, isCircle: true),
                    const SizedBox(height: 8),
                    _buildShimmerContainer(80, 12, borderRadius: 8),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Animated divider
            _buildShimmerDivider(),
            const SizedBox(height: 15),

            // Stats section
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildStatCardShimmer()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCardShimmer()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppConstants.appPrimaryColor.withOpacity(0.3),
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
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.appPrimaryColor.withOpacity(0.3),
                ),
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
                  AppConstants.appPrimaryColor.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.appPrimaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildShimmerContainer(20, 20, isCircle: true),
          const SizedBox(height: 6),
          _buildShimmerContainer(60, 10),
          const SizedBox(height: 4),
          _buildShimmerContainer(40, 12),
        ],
      ),
    );
  }

  Widget _buildMarqueeShimmer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.appPrimaryColor.withOpacity(0.7),
            AppConstants.appPrimaryColor.withOpacity(0.5),
            AppConstants.appPrimaryColor.withOpacity(0.7),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.appPrimaryColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left icon section
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppConstants.black.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              border: Border(
                right: BorderSide(
                  color: AppConstants.black.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.campaign_rounded,
                  color: AppConstants.black,
                  size: 20,
                ),
              ),
            ),
          ),

          // Center text shimmer
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: _buildShimmerContainer(200, 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerShimmer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Main banner shimmer
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF1A1A2E).withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildShimmerContainer(
                    double.infinity,
                    200,
                    borderRadius: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Indicators shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: index == 0 ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: index == 0
                      ? AppConstants.appPrimaryColor
                      : AppConstants.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSpinGamesShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title shimmer
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade500],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.casino, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              _buildShimmerContainer(120, 22),
            ],
          ),
        ),

        // Spin games grid shimmer
        Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _buildSpinGameCardShimmer(Colors.orange)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSpinGameCardShimmer(AppConstants.appPrimaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpinGameCardShimmer(Color baseColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withOpacity(0.7),
            baseColor.withOpacity(0.5),
            baseColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and badge row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShimmerContainer(44, 44, borderRadius: 12),
                _buildShimmerContainer(60, 20, borderRadius: 20),
              ],
            ),

            const Spacer(),

            // Title
            _buildShimmerContainer(80, 18),
            const SizedBox(height: 4),

            // Subtitle
            _buildShimmerContainer(120, 12),
            const SizedBox(height: 2),
            _buildShimmerContainer(100, 12),

            const SizedBox(height: 8),

            // Action row
            _buildShimmerContainer(70, 12),
          ],
        ),
      ),
    );
  }

  Widget _buildEssentialsShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title shimmer
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.appPrimaryColor.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildShimmerContainer(100, 22),
          ),
        ),
        const SizedBox(height: 16),

        // Grid shimmer
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: 4, // Match the actual number of items
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1A1A1A).withOpacity(0.8),
                      const Color(0xFF2A2A2A).withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppConstants.white.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image shimmer
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.appPrimaryColor.withOpacity(
                                0.2,
                              ),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildShimmerContainer(
                            double.infinity,
                            double.infinity,
                            borderRadius: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Text shimmer
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [_buildShimmerContainer(80, 12)],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerContainer(
    double width,
    double height, {
    bool isCircle = false,
    double? borderRadius,
  }) {
    return SkeletonAnimation(
      shimmerColor: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(
        isCircle ? height / 2 : borderRadius ?? 4,
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(
            isCircle ? height / 2 : borderRadius ?? 4,
          ),
        ),
      ),
    );
  }
}
