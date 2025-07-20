import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../../core/widgets/vcart_button.dart';
import '../../domain/entities/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;
  final VoidCallback onMoveToWishlist;
  final bool isUpdating;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    required this.onMoveToWishlist,
    this.isUpdating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: VCartColors.border.withOpacity(0.3),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildItemContent(context),
          if (item.couponDiscount > 0) _buildCouponSavings(context),
          _buildItemActions(context),
        ],
      ),
    );
  }

  Widget _buildItemContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _buildItemImage(),
          const SizedBox(width: 12),
          Expanded(child: _buildItemDetails(context)),
        ],
      ),
    );
  }

  Widget _buildItemImage() {
    return Container(
      height: 100,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: VCartColors.surface,
      ),
      child: CachedNetworkImage(
        imageUrl: item.primaryImage.orPlaceholder,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: VCartColors.surface,
          ),
          child: const Center(
            child: Icon(
              Icons.image_outlined,
              color: VCartColors.textSecondary,
              size: 32,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: VCartColors.surface,
          ),
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: VCartColors.textSecondary,
              size: 32,
            ),
          ),
        ),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: VCartColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: VCartColors.surface,
              ),
              child: Text(
                item.size,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: VCartColors.textPrimary,
                ),
              ),
            ),
            const Spacer(),
            _buildPriceSection(),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (item.hasDiscount)
          Text(
            VCartHelpers.calculateProductPrice(
              item.price,
              item.commission,
            ).formatPrice,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: VCartColors.error,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        Text(
          VCartHelpers.calculateProductPrice(
            item.offerPrice,
            item.commission,
          ).formatPrice,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: VCartColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCouponSavings(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: VCartColors.success.withOpacity(0.1),
      child: Text(
        "Congratulations! You Saved ${item.couponDiscount.formatPrice} on This Item with the Applied Coupon",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: VCartColors.success,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildItemActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: VCartColors.border.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          VCartButton(
            text: "Move to Wishlist",
            onPressed: isUpdating ? null : onMoveToWishlist,
            type: VCartButtonType.tertiary,
          ),
          const Spacer(),
          _buildQuantityControls(),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isUpdating ? null : onRemove,
            icon: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: VCartColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: VCartColors.error,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: VCartColors.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: isUpdating ? null : onDecrement,
            icon: CircleAvatar(
              backgroundColor: VCartColors.background,
              radius: 12,
              child: Icon(
                item.quantity <= 1 ? Icons.delete_outline : Icons.remove,
                color: VCartColors.error,
                size: 16,
              ),
            ),
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.quantity.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: VCartColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isUpdating ? null : onIncrement,
            icon: const CircleAvatar(
              backgroundColor: VCartColors.background,
              radius: 12,
              child: Icon(Icons.add, color: VCartColors.primary, size: 16),
            ),
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
