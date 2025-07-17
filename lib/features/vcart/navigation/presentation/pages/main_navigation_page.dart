import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/route_constants.dart';
import '../../../core/constants/vcart_colors.dart';
import '../controllers/bottom_nav_controller.dart';

class VCartMainNavigationPage extends StatelessWidget {
  final List<Widget> pages;
  final VoidCallback? onMarketplaceTap;

  const VCartMainNavigationPage({
    super.key,
    required this.pages,
    this.onMarketplaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VCartBottomNavController>(
      init: Get.find<VCartBottomNavController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: VCartColors.background,
          body: PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.setCurrentIndex(index);
            },
            children: pages,
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              context.go(RouteConstants.home);
            },
            backgroundColor: VCartColors.primaryOpacity(0.2),
            foregroundColor: VCartColors.onPrimary,
            elevation: 4,
            child: Image.asset('assets/animation/vivera-animation.gif'),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            color: VCartColors.surface,
            shape: const CircularNotchedRectangle(),
            notchMargin: 6.0,
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                if (controller.isLoading || controller.navItems.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(controller.navItems[0], controller),
                    _buildNavItem(controller.navItems[1], controller),
                    const SizedBox(width: 40),
                    _buildNavItem(controller.navItems[2], controller),
                    _buildNavItem(controller.navItems[3], controller),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(dynamic item, VCartBottomNavController controller) {
    final isSelected = controller.currentIndex == item.id;

    return GestureDetector(
      onTap: () => controller.setCurrentIndex(item.id),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _getIcon(item, isSelected),
                size: 24,
                color: isSelected
                    ? VCartColors.primary
                    : VCartColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? VCartColors.primary
                    : VCartColors.textSecondary,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(dynamic item, bool isSelected) {
    if (item.iconData != null) {
      if (isSelected && item.activeIconData != null) {
        return item.activeIconData!;
      }
      return item.iconData!;
    }
    switch (item.id) {
      case 0:
        return isSelected ? Icons.home : Icons.home_outlined;
      case 1:
        return isSelected ? Icons.category : Icons.category_outlined;
      case 2:
        return isSelected ? Icons.shopping_cart : Icons.shopping_cart_outlined;
      case 3:
        return isSelected ? Icons.person : Icons.person_outline;
      default:
        return Icons.help_outline;
    }
  }
}
