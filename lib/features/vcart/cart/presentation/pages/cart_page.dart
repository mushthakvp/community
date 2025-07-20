import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/di/vcart_dependency_injection.dart';
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
  VCartCartController? controller;
  bool isInitializing = true;
  String? initializationError;

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    try {
      // Ensure VCart DI is initialized
      if (!VCartDI.isInitialized) {
        debugPrint('🔄 VCart DI not initialized, initializing now...');
        await VCartDI.init();
      }

      // Wait a bit to ensure all dependencies are registered
      await Future.delayed(const Duration(milliseconds: 100));

      // Try to get the controller
      if (Get.isRegistered<VCartCartController>()) {
        controller = Get.find<VCartCartController>();
        debugPrint('✅ VCartCartController found successfully');
      } else {
        throw Exception(
          'VCartCartController not registered after DI initialization',
        );
      }

      if (mounted) {
        setState(() {
          isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to initialize cart page: $e');
      if (mounted) {
        setState(() {
          isInitializing = false;
          initializationError = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VCartColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
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
    // Show loading while initializing
    if (isInitializing) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: VCartColors.primary,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Loading cart...',
              style: TextStyle(color: VCartColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    // Show error if initialization failed
    if (initializationError != null || controller == null) {
      return Center(
        child: VCartErrorWidget(
          message:
              initializationError ??
              'Cart service is not available. Please try again.',
          onRetry: () {
            setState(() {
              isInitializing = true;
              initializationError = null;
            });
            _initializeAsync();
          },
        ),
      );
    }

    // Build normal cart UI
    return GetBuilder<VCartCartController>(
      init: controller,
      builder: (cartController) {
        return Obx(() => _buildCartContent(cartController));
      },
    );
  }

  Widget _buildCartContent(VCartCartController cartController) {
    if (cartController.hasError) {
      return VCartErrorWidget(
        message: cartController.errorMessage,
        onRetry: () => cartController.refreshCartData(),
      );
    }

    if (cartController.isEmpty && !cartController.isLoading) {
      return const VCartMaintenanceWidget(
        imageUrl:
            'https://res.cloudinary.com/fouvtycloud/image/upload/v1732792361/Delivery_Service_1_gj5xfk.png',
        title: 'Your Cart is Empty',
        subtitle:
            'Looks like you haven\'t added anything yet. Start shopping to fill it up!',
      );
    }

    return RefreshIndicator(
      onRefresh: cartController.refreshCartData,
      color: VCartColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Skeletonizer(
          enabled: cartController.isLoading,
          child: Column(
            children: [
              if (cartController.isNotEmpty) ...[
                _buildCartItems(cartController),
                _buildCartFooter(cartController),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItems(VCartCartController cartController) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: context.defaultPadding,
      itemCount: cartController.cartItems.length,
      itemBuilder: (context, index) {
        return CartItemWidget(
          item: cartController.cartItems[index],
          onIncrement: () => cartController.incrementQuantity(
            cartController.cartItems[index],
            context,
          ),
          onDecrement: () => cartController.decrementQuantity(
            cartController.cartItems[index],
            context,
          ),
          onRemove: () => cartController.removeItem(
            cartController.cartItems[index],
            context,
          ),
          onMoveToWishlist: () => cartController.moveItemToWishlist(
            cartController.cartItems[index],
            context,
          ),
          isUpdating: cartController.isUpdating,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
    );
  }

  Widget _buildCartFooter(VCartCartController cartController) {
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
          if (cartController.hasCoupon)
            AppliedCouponWidget(
              couponData: cartController.cartData!.couponData!,
              onRemove: () => cartController.removeCouponFromCart(context),
              isLoading: cartController.isUpdating,
            )
          else
            CouponSelectorWidget(
              onCouponApplied: (couponId) =>
                  cartController.applyCouponWithId(couponId, context),
            ),

          const SizedBox(height: 20),

          // Cart Summary
          CartSummaryWidget(cartData: cartController.cartData!),

          const SizedBox(height: 16),

          // Checkout Button
          VCartButton(
            text: "Proceed to Checkout",
            onPressed: cartController.isUpdating ? null : _onCheckoutPressed,
            isLoading: cartController.isUpdating,
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
