import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../controllers/bottom_nav_controller.dart';
import '../widgets/bottom_nav_bar.dart';

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
          bottomNavigationBar: VCartBottomNavBar(
            onFloatingActionButtonTap:
                onMarketplaceTap ??
                () {
                  Get.toNamed('/marketplace');
                },
          ),
        );
      },
    );
  }
}
