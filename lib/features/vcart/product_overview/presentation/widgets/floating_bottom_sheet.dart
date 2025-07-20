import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_button.dart';
import '../controllers/product_overview_controller.dart';

class FloatingBottomSheet extends StatelessWidget {
  final VCartProductOverviewController controller;
  final Animation<Offset> animation;

  const FloatingBottomSheet({
    super.key,
    required this.controller,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
        height: context.screenHeight * 0.1,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: VCartColors.surfaceOpacity(0.9),
        ),
        child: Obx(
          () => Row(
            children: [
              _buildPriceSection(),
              const Spacer(),
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Price",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: VCartColors.textSecondary,
          ),
        ),
        Text.rich(
          TextSpan(
            text: "RS.${controller.finalOfferPrice.toStringAsFixed(2)} ",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: VCartColors.textPrimary,
            ),
            children: [
              if (controller.hasDiscount)
                TextSpan(
                  text: "RS.${controller.finalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: VCartColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final selectedSize = controller.selectedSize;
    final isInCart = selectedSize?.isAddedCart ?? false;

    return VCartButton(
      text: isInCart ? 'Go to Cart' : "Add to Cart",
      onPressed: () {
        if (isInCart) {
          VCartRouterClassG.toVCartCart();
        } else {
          controller.addToCart(context);
        }
      },
      isLoading: controller.isAddingToCart,
      width: context.screenWidth * 0.4,
      height: context.screenHeight * 0.06,
    );
  }
}
