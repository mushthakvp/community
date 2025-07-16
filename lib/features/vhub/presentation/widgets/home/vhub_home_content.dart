import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import 'vhub_features_grid.dart';
import 'vhub_info_carousel.dart';
import 'vhub_stats_section.dart';

class VHubHomeContent extends StatelessWidget {
  const VHubHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppConstants.black, AppConstants.black.withOpacity(0.9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Welcome Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonTextWidget(
                    text: 'Welcome to V-Hub',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.appPrimaryColor,
                  ),
                  const SizedBox(height: 8),
                  CommonTextWidget(
                    text: 'Your Business Startup Platform',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppConstants.white.withOpacity(0.8),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Info Carousel
            const VHubInfoCarousel(),

            const SizedBox(height: 30),

            // Stats Section
            const VHubStatsSection(),

            const SizedBox(height: 30),

            // Features Grid
            const VHubFeaturesGrid(),

            const SizedBox(height: 30),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppConstants.white.withOpacity(0.1),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      text: 'About V-Hub',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.appPrimaryColor,
                    ),
                    SizedBox(height: 16),
                    CommonTextWidget(
                      text:
                          "V-Hub is Livera's Business Startup Platform that helps entrepreneurs and students apply their expertise and research for wider social and economic benefit. We support you in bringing the benefits of your research and expertise to create impact in wider society.",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white,
                      maxLines: 10,
                      align: TextAlign.left,
                    ),
                    SizedBox(height: 16),
                    CommonTextWidget(
                      text:
                          "Our platform offers comprehensive support through three phases: Prepare, Build, and Deliver. Each phase provides targeted assistance to help transform your ideas into successful ventures.",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white,
                      maxLines: 10,
                      align: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
