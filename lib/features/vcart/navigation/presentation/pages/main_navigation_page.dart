import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/route_constants.dart';
import '../../../core/constants/vcart_colors.dart';
import '../controllers/bottom_nav_controller.dart';

class VCartMainNavigationPage extends StatefulWidget {
  final List<Widget> pages;
  final VoidCallback? onMarketplaceTap;

  const VCartMainNavigationPage({
    super.key,
    required this.pages,
    this.onMarketplaceTap,
  });

  @override
  State<VCartMainNavigationPage> createState() =>
      _VCartMainNavigationPageState();
}

class _VCartMainNavigationPageState extends State<VCartMainNavigationPage> {
  late VCartBottomNavController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VCartBottomNavController>();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VCartBottomNavController>(
      init: controller,
      builder: (navController) {
        return Scaffold(
          backgroundColor: VCartColors.background,
          body: PageView(
            controller: navController.pageController,
            onPageChanged: (index) {
              navController.onPageChanged(index);
            },
            children: widget.pages,
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              if (context.mounted) {
                try {
                  context.go(RouteConstants.home);
                } catch (e) {
                  if (widget.onMarketplaceTap != null) {
                    widget.onMarketplaceTap!();
                  }
                }
              }
            },
            backgroundColor: VCartColors.primaryOpacity(0.2),
            foregroundColor: VCartColors.onPrimary,
            elevation: 4,
            child: Image.asset(
              'assets/animation/vivera-animation.gif',
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.home, color: VCartColors.primary);
              },
            ),
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
                if (navController.isLoading || navController.navItems.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(navController.navItems[0], navController),
                    _buildNavItem(navController.navItems[1], navController),
                    const SizedBox(width: 40),
                    _buildNavItem(navController.navItems[2], navController),
                    _buildNavItem(navController.navItems[3], navController),
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
      onTap: () {
        controller.setCurrentIndex(item.id);
      },
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
