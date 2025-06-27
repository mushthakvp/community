// features/home/presentation/widgets/home_shimmer.dart
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../../../../core/constants/app_constants.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/videos/moon.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildTopBarShimmer(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildLoyaltyCardShimmer(context),
                    const SizedBox(height: 20),
                    _buildMarqueeShimmer(context),
                    const SizedBox(height: 20),
                    _buildBannerShimmer(context),
                    const SizedBox(height: 30),
                    _buildEssentialsShimmer(context),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarShimmer(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildShimmerContainer(28, 28, isCircle: false),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerContainer(100, 16),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(80, 12),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                _buildShimmerContainer(24, 24, isCircle: false),
                const SizedBox(width: 16),
                _buildShimmerContainer(24, 24, isCircle: false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyCardShimmer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: MediaQuery.of(context).size.height * 0.24,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image shimmer
            _buildShimmerContainer(70, 70, isCircle: true),
            const SizedBox(width: 16),

            // Center content shimmer
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title shimmer
                  _buildShimmerContainer(200, 20),
                  const SizedBox(height: 8),

                  // Divider (using actual SVG if available)
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppConstants.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // First row of info fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildShimmerFieldGroup(),
                      const SizedBox(width: 20),
                      _buildShimmerFieldGroup(),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Second row of info fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildShimmerFieldGroup(),
                      const SizedBox(width: 20),
                      _buildShimmerFieldGroup(),
                    ],
                  ),
                ],
              ),
            ),

            // Logo shimmer
            _buildShimmerContainer(60, 60, isCircle: true),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerFieldGroup() {
    return Column(
      children: [
        _buildShimmerContainer(40, 8),
        const SizedBox(height: 4),
        _buildShimmerContainer(60, 12),
      ],
    );
  }

  Widget _buildMarqueeShimmer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          // Left icon shimmer
          Container(
            width: 50,
            height: 45,
            color: Colors.black.withOpacity(0.2),
            child: const Icon(
              Icons.campaign_outlined,
              color: Colors.grey,
              size: 20,
            ),
          ),

          // Center text shimmer
          Expanded(child: Center(child: _buildShimmerContainer(250, 14))),

          // Right icon shimmer
          Container(
            width: 50,
            height: 45,
            color: Colors.black.withOpacity(0.2),
            child: const Icon(Icons.info_outline, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerShimmer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 200,
      child: Row(
        children: [
          const SizedBox(width: 5),
          Expanded(
            child: _buildShimmerContainer(
              double.infinity,
              200,
              borderRadius: 20,
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _buildEssentialsShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title shimmer
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: _buildShimmerContainer(100, 18),
        ),
        const SizedBox(height: 16),

        // Grid shimmer
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppConstants.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    // App icon shimmer
                    Expanded(
                      flex: 3,
                      child: _buildShimmerContainer(
                        double.infinity,
                        double.infinity,
                        borderRadius: 12,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // App name shimmer
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildShimmerContainer(60, 12),
                          const SizedBox(height: 4),
                          _buildShimmerContainer(80, 8),
                        ],
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
      shimmerColor: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(
        isCircle ? height / 2 : borderRadius ?? 4,
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(
            isCircle ? height / 2 : borderRadius ?? 4,
          ),
        ),
      ),
    );
  }
}
