// features/home/presentation/widgets/essentials_grid.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class EssentialsGrid extends StatelessWidget {
  const EssentialsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _getEssentialItems();

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildEssentialItem(context, item);
      },
    );
  }

  List<EssentialItem> _getEssentialItems() {
    return [
      EssentialItem(
        image:
            "https://res.cloudinary.com/fouvtycloud/image/upload/v1751013407/Vivera-New/ecommerceLogo_hszwpi.gif",
        name: "V - Cart",
        route: '/v-cart',
        description: "Shop online with exclusive deals",
        isExternal: false,
      ),
      EssentialItem(
        image:
            "https://res.cloudinary.com/fouvtycloud/image/upload/v1751012822/Vivera-New/v-hub.gif",
        name: "V - Hub",
        route: '/v-hub',
        description: "Business and startup support",
        isExternal: false,
      ),
      EssentialItem(
        image:
            "https://res.cloudinary.com/fouvtycloud/image/upload/v1751012835/Vivera-New/vjob_ukw0w9.gif",
        name: "V - Job",
        route: '/v-job',
        description: "Find your dream job",
        isExternal: false,
      ),
      EssentialItem(
        image:
            "https://res.cloudinary.com/fouvtycloud/image/upload/v1751012824/Vivera-New/v-one_rkshfo.gif",
        name: "V - One",
        route: RouteConstants.coupons,
        description: "Exclusive coupons and offers",
        isExternal: false,
        isNavigationRoute: true,
      ),
    ];
  }

  Widget _buildEssentialItem(BuildContext context, EssentialItem item) {
    return GestureDetector(
      onTap: () => _handleItemTap(context, item),
      child: AnimatedContainer(
        duration: AppConstants.defaultAnimationDuration,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1A1A),
              const Color(0xFF2A2A2A).withOpacity(0.8),
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
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.appPrimaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildItemImage(item),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonTextWidget(
                    text: item.name,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.white,
                    align: TextAlign.center,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(EssentialItem item) {
    return CachedNetworkImage(
      imageUrl: item.image,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          color: AppConstants.appPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppConstants.appPrimaryColor.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Loading...',
                style: TextStyle(
                  color: AppConstants.white.withOpacity(0.6),
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ),
      ),
      errorWidget: (context, url, error) => _buildErrorImage(),
      imageBuilder: (context, imageProvider) => Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.apps,
        color: AppConstants.appPrimaryColor,
        size: 30,
      ),
    );
  }

  void _handleItemTap(BuildContext context, EssentialItem item) {
    if (item.isExternal) {
      _launchExternalApp(context, item);
    } else if (item.isNavigationRoute) {
      // Navigate to the specified route (for V-One -> Coupons)
      context.go(item.route);
    } else {
      _navigateToRoute(context, item.route);
    }
  }

  void _navigateToRoute(BuildContext context, String route) {
    // Handle internal navigation for other items
    switch (route) {
      case '/v-cart':
        // Navigate to ecommerce section
        _showComingSoon(context, "V-Cart");
        break;
      case '/v-hub':
        // Navigate to business hub
        _showComingSoon(context, "V-Hub");
        break;
      case '/v-job':
        // Navigate to job portal
        _showComingSoon(context, "V-Job");
        break;
      case '/wallet':
        // Navigate to wallet section
        _showComingSoon(context, "V-Cash");
        break;
      default:
        _showComingSoon(context, "Feature");
        break;
    }
  }

  Future<void> _launchExternalApp(
    BuildContext context,
    EssentialItem item,
  ) async {
    try {
      // Try to launch the app using URL scheme
      if (item.route.isNotEmpty) {
        final Uri uri = Uri.parse(item.route);
        final bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          // If app is not installed, open the appropriate store
          _openAppStore(context, item);
        }
      } else {
        _openAppStore(context, item);
      }
    } catch (e) {
      // If there's any error, try to open the store
      _openAppStore(context, item);
    }
  }

  Future<void> _openAppStore(BuildContext context, EssentialItem item) async {
    try {
      Uri storeUri;

      // For iOS
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        storeUri = Uri.parse(
          'https://apps.apple.com/app/id${item.appStoreId ?? ''}',
        );
      } else {
        // For Android
        storeUri = Uri.parse(
          'https://play.google.com/store/apps/details?id=${item.appPackageName ?? ''}',
        );
      }

      final bool launched = await launchUrl(
        storeUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showErrorMessage(context, "Could not open app store");
      }
    } catch (e) {
      _showErrorMessage(context, "Error opening app store");
    }
  }

  void _showComingSoon(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName - Coming Soon!'),
        backgroundColor: AppConstants.appPrimaryColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class EssentialItem {
  final String name;
  final String image;
  final String route;
  final String description;
  final bool isExternal;
  final bool isNavigationRoute; // New field to indicate navigation routes
  final String? appPackageName;
  final String? appStoreId;

  const EssentialItem({
    required this.name,
    required this.image,
    required this.route,
    this.description = '',
    this.isExternal = false,
    this.isNavigationRoute = false,
    this.appPackageName,
    this.appStoreId,
  });
}
