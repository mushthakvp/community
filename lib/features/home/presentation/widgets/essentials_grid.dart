import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../vcart/core/router/v_cart_router_g.dart';
import '../../../vcart/core/router/vcart_router.dart';

class EssentialsGrid extends StatelessWidget {
  const EssentialsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _getEssentialItems();

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
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
            "https://res.cloudinary.com/fouvtycloud/image/upload/v1751012822/Vivera-New/v-hub.gif",
        name: "V - Hub",
        route: RouteConstants.vhubHome,
        description: "Business and startup support",
        isExternal: false,
        isNavigationRoute: true,
      ),
      EssentialItem(
        image:
            "https://res.cloudinary.com/fouvtycloud/image/upload/v1751012835/Vivera-New/vjob_ukw0w9.gif",
        name: "V - Job",
        route: RouteConstants.vjobHome,
        description: "Find your dream job",
        isExternal: false,
        isNavigationRoute: true,
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
      EssentialItem(
        image:
            "https://res.cloudinary.com/fouvtycloud/image/upload/v1751013407/Vivera-New/ecommerceLogo_hszwpi.gif",
        name: "V - Cart",
        route: VCartRouterClass.home,
        description: "Shop online with exclusive deals",
        isExternal: false,
        isNavigationRoute: true,
      ),
      EssentialItem(
        image:
            "https://res.cloudinary.com/fouvtycloud/image/upload/v1753158174/Vivera-New/vcook_gam4b9.gif",
        name: "V - Cook",
        route: RouteConstants.vcook,
        description: "Cook your favorite dishes",
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
    if (item.route == VCartRouterClass.home) {
      VCartRouterClassG.toVCartHome();
    } else if (item.route == RouteConstants.vcook) {
      openCookingApp(context);
    } else {
      context.push(item.route);
    }
  }

  static const String cookingAppBundleId = 'com.vivera.cooking';
  static const String appleAppId = '6744088577';

  Future<void> openCookingApp(BuildContext context) async {
    try {
      if (Platform.isIOS) {
        final Uri appUri = Uri.parse('$cookingAppBundleId://');
        if (await canLaunchUrl(appUri)) {
          await launchUrl(appUri, mode: LaunchMode.externalApplication);
        } else {
          await _openAppStore();
        }
      } else if (Platform.isAndroid) {
        final Uri appUri = Uri.parse('$cookingAppBundleId://');
        if (await canLaunchUrl(appUri)) {
          await launchUrl(appUri, mode: LaunchMode.externalApplication);
        } else {
          final Uri playStoreUri = Uri.parse(
            'market://details?id=$cookingAppBundleId',
          );
          if (await canLaunchUrl(playStoreUri)) {
            await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
          } else {
            final Uri webPlayStore = Uri.parse(
              'https://play.google.com/store/apps/details?id=$cookingAppBundleId',
            );
            await launchUrl(webPlayStore, mode: LaunchMode.externalApplication);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open the Cooking App: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openAppStore() async {
    final Uri appStoreUri = Uri.parse(
      'https://apps.apple.com/app/id$appleAppId',
    );
    if (await canLaunchUrl(appStoreUri)) {
      await launchUrl(appStoreUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open App Store';
    }
  }
}

class EssentialItem {
  final String name;
  final String image;
  final String route;
  final String description;
  final bool isExternal;
  final bool isNavigationRoute;
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
