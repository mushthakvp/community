import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/router/vcart_router.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_action_item.dart';
import '../widgets/profile_header.dart';

class VCartProfilePage extends StatelessWidget {
  const VCartProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VCartProfileController>(
      init: Get.find<VCartProfileController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: VCartColors.background,
          appBar: _buildAppBar(),
          body: Obx(() {
            if (controller.hasError) {
              return VCartErrorWidget(
                message: controller.errorMessage,
                onRetry: () => controller.refreshData(),
              );
            }

            return Skeletonizer(
              enabled: controller.isLoading,
              child: SingleChildScrollView(
                padding: context.defaultPadding,
                child: Column(
                  children: [
                    ProfileHeader(controller: controller),
                    SizedBox(height: context.screenHeight * 0.04),
                    _buildProfileActions(context),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VCartColors.background,
      automaticallyImplyLeading: false,
      title: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: VCartColors.textPrimary,
        ),
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  Widget _buildProfileActions(BuildContext context) {
    return Column(
      children: [
        ProfileActionItem(
          title: 'My Orders',
          icon: Icons.shopping_bag_outlined,
          onTap: () => _navigateToOrders(),
        ),
        _buildDivider(),
        ProfileActionItem(
          title: 'Wishlist',
          icon: Icons.favorite_outline,
          onTap: () => _navigateToWishlist(),
        ),
        _buildDivider(),
        ProfileActionItem(
          title: 'Saved Address',
          icon: Icons.location_on_outlined,
          onTap: () => _navigateToSavedAddress(),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: VCartColors.border,
      height: 1,
      indent: 22,
      endIndent: 22,
    );
  }

  // Navigation methods
  void _navigateToOrders() {
    // Navigate to orders page
    Get.toNamed('/orders');
  }

  void _navigateToWishlist() {
    VCartRouter.toVCartCategory('wishlist');
  }

  void _navigateToSavedAddress() {
    Get.toNamed('/saved-address');
  }
}
