import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/card_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class VizzleHomePage extends StatelessWidget {
  const VizzleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(
        title: "Vizzle Marketplace",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // Categories Section
            _buildCategoriesSection(),
            const SizedBox(height: 24),

            // Recent Ads Section
            _buildRecentAdsSection(context),
            const SizedBox(height: 24),

            // Create Ad CTA
            _buildCreateAdCTA(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.appPrimaryColor.withOpacity(0.8),
            AppConstants.appPrimaryColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CommonTextWidget(
            text: "Welcome to Vizzle",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.black,
          ),
          const SizedBox(height: 8),
          const CommonTextWidget(
            text: "Buy, sell, and discover amazing deals in your community",
            fontSize: 14,
            color: AppConstants.black,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.trending_up, color: AppConstants.black, size: 20),
              const SizedBox(width: 8),
              const CommonTextWidget(
                text: "1000+ Active Listings",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: "Quick Actions",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.add_circle_outline,
                title: "Create Ad",
                subtitle: "Sell your items",
                color: Colors.green,
                onTap: () => context.go(RouteConstants.createAd),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.search,
                title: "Browse Ads",
                subtitle: "Find great deals",
                color: Colors.blue,
                onTap: () => context.go(RouteConstants.adsListing),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.favorite_outline,
                title: "Saved Ads",
                subtitle: "Your favorites",
                color: Colors.red,
                onTap: () => context.go(RouteConstants.savedAds),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.person_outline,
                title: "My Profile",
                subtitle: "Manage account",
                color: Colors.purple,
                onTap: () => context.go(RouteConstants.vizzleProfile),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CommonCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            CommonTextWidget(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              align: TextAlign.center,
            ),
            const SizedBox(height: 4),
            CommonTextWidget(
              text: subtitle,
              fontSize: 12,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'name': 'Motors', 'icon': Icons.directions_car, 'color': Colors.blue},
      {'name': 'Electronics', 'icon': Icons.devices, 'color': Colors.green},
      {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.purple},
      {'name': 'Home & Garden', 'icon': Icons.home, 'color': Colors.orange},
      {'name': 'Sports', 'icon': Icons.sports_basketball, 'color': Colors.red},
      {'name': 'Books', 'icon': Icons.book, 'color': Colors.teal},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: "Browse Categories",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              icon: category['icon'] as IconData,
              name: category['name'] as String,
              color: category['color'] as Color,
              onTap: () {
                // Navigate to category listing
                context.go(
                  '${RouteConstants.categoryListing}?category=${category['name']}',
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String name,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CommonCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: name,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              align: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAdsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonTextWidget(
              text: "Recent Ads",
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            GestureDetector(
              onTap: () => context.go(RouteConstants.adsListing),
              child: const CommonTextWidget(
                text: "View All",
                fontSize: 14,
                color: AppConstants.appPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildAdCard(
                title: "Sample Ad ${index + 1}",
                price: "\$${(index + 1) * 100}",
                location: "City ${index + 1}",
                imageUrl: null,
                onTap: () {
                  // Navigate to ad details
                  context.go(
                    '${RouteConstants.adDetails}?adId=sample-${index + 1}',
                  );
                },
                onEdit: () {
                  // Navigate to edit ad - example with mock data
                  context.go('${RouteConstants.editAd}/sample-${index + 1}');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdCard({
    required String title,
    required String price,
    required String location,
    String? imageUrl,
    required VoidCallback onTap,
    VoidCallback? onEdit,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: CommonCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppConstants.surfaceContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.defaultBorderRadius),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 32,
                    color: AppConstants.white.withOpacity(0.5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      text: title,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    CommonTextWidget(
                      text: price,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.appPrimaryColor,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppConstants.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: CommonTextWidget(
                            text: location,
                            fontSize: 12,
                            color: AppConstants.white.withOpacity(0.6),
                            maxLines: 1,
                          ),
                        ),
                        if (onEdit != null)
                          GestureDetector(
                            onTap: onEdit,
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: AppConstants.appPrimaryColor,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAdCTA(BuildContext context) {
    return CommonCard(
      backgroundColor: AppConstants.surfaceVariant,
      child: Column(
        children: [
          Icon(
            Icons.add_circle_outline,
            size: 48,
            color: AppConstants.appPrimaryColor,
          ),
          const SizedBox(height: 16),
          const CommonTextWidget(
            text: "Ready to sell something?",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text:
                "Create your first ad and reach thousands of potential buyers",
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.7),
            align: TextAlign.center,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: "Create Your First Ad",
            onPressed: () => context.go(RouteConstants.createAd),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
