import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../domain/entities/nav_item.dart';
import '../controllers/bottom_nav_controller.dart';
import 'bottom_nav_painter.dart';
import 'nav_item_widget.dart';

class VCartBottomNavBar extends StatelessWidget {
  final VoidCallback? onFloatingActionButtonTap;

  const VCartBottomNavBar({super.key, this.onFloatingActionButtonTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VCartBottomNavController>(
      builder: (controller) {
        return Obx(() {
          if (controller.isLoading || controller.navItems.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            height: 80,
            decoration: BoxDecoration(
              color: VCartColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 80),
                  painter: BottomNavPainter(),
                ),
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, -10),
                    child: FloatingActionButton(
                      onPressed: onFloatingActionButtonTap,
                      backgroundColor: VCartColors.primary,
                      elevation: 4,
                      child: const Text('🛍️', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(controller.navItems[0], controller),
                      _buildNavItem(controller.navItems[1], controller),
                      const SizedBox(width: 60),
                      _buildNavItem(controller.navItems[2], controller),
                      _buildNavItem(controller.navItems[3], controller),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildNavItem(NavItem item, VCartBottomNavController controller) {
    return NavItemWidget(
      item: item,
      isSelected: controller.currentIndex == item.id,
      onTap: () => controller.setCurrentIndex(item.id),
    );
  }
}
