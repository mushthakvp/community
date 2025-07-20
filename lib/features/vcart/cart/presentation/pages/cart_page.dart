import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_button.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/cart_controller.dart';
import '../widgets/applied_coupon_widget.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary_widget.dart';
import '../widgets/coupon_selector_widget.dart';

class VCartCartPage extends StatefulWidget {
  final bool showBackButton;

  const VCartCartPage({super.key, this.showBackButton = false});

  @override
  State<VCartCartPage> createState() => _VCartCartPageState();
}

class _VCartCartPageState extends State<VCartCartPage> {
  late VCartCartController controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (Get.isRegistered<VCartCartController>()) {
      controller = Get.find<VCartCartController>();
    } else {
      // Initialize controller if not already registered
      // This would be done through dependency injection
      throw Exception('VCartCartController not registered');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VCartColors.background,
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VCartColors.background,
      elevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: widget.showBackButton,
      leading: widget.showBackButton
          ? IconButton(
              onPressed: () => VCartRouterClassG.backInVCart(),
              icon: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: VCartColors.border, width: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: VCartColors.textPrimary,
                ),
              ),
            )
          : null,
      title: const Text(
        "My Cart",
        style: TextStyle(
          color: VCartColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.hasError) {
      return VCartErrorWidget(
        message: controller.errorMessage,
        onRetry: () => controller.refreshCartData(),
      );
    }

    if (controller.isEmpty && !controller.isLoading) {
      return const VCartMaintenanceWidget(
        imageUrl:
            'https://res.cloudinary.com/fouvtycloud/image/upload/v1732792361/Delivery_Service_1_gj5xfk.png',
        title: 'Your Cart is Empty',
        subtitle:
            'Looks like you haven\'t added anything yet. Start shopping to fill it up!',
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshCartData,
      color: VCartColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Skeletonizer(
          enabled: controller.isLoading,
          child: Column(
            children: [
              if (controller.isNotEmpty) ...[
                _buildCartItems(),
                _buildCartFooter(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItems() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: context.defaultPadding,
      itemCount: controller.cartItems.length,
      itemBuilder: (context, index) {
        return CartItemWidget(
          item: controller.cartItems[index],
          onIncrement: () => controller.incrementQuantity(
            controller.cartItems[index],
            context,
          ),
          onDecrement: () => controller.decrementQuantity(
            controller.cartItems[index],
            context,
          ),
          onRemove: () =>
              controller.removeItem(controller.cartItems[index], context),
          onMoveToWishlist: () => controller.moveItemToWishlist(
            controller.cartItems[index],
            context,
          ),
          isUpdating: controller.isUpdating,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  Widget _buildCartFooter() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: context.defaultPadding,
      decoration: const BoxDecoration(
        color: VCartColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Coupon Section
          if (controller.hasCoupon)
            AppliedCouponWidget(
              couponData: controller.cartData!.couponData!,
              onRemove: () => controller.removeCouponFromCart(context),
              isLoading: controller.isUpdating,
            )
          else
            CouponSelectorWidget(
              onCouponApplied: (couponId) =>
                  controller.applyCouponWithId(couponId, context),
            ),

          const SizedBox(height: 20),

          // Cart Summary
          CartSummaryWidget(cartData: controller.cartData!),

          const SizedBox(height: 16),

          // Checkout Button
          VCartButton(
            text: "Proceed to Checkout",
            onPressed: controller.isUpdating ? null : _onCheckoutPressed,
            isLoading: controller.isUpdating,
            isExpanded: true,
            height: 55,
          ),

          SizedBox(height: context.screenHeight * 0.1),
        ],
      ),
    );
  }

  void _onCheckoutPressed() {
    // Navigate to checkout
    Get.toNamed('/checkout');
  }
}
