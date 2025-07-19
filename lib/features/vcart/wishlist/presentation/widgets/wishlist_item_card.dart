import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../domain/entities/wishlist_item.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: VCartColors.cardBackground,
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          border: Border.all(color: VCartColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(VCartConstants.defaultRadius),
                topRight: Radius.circular(VCartConstants.defaultRadius),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(VCartConstants.defaultRadius),
                topRight: Radius.circular(VCartConstants.defaultRadius),
              ),
              child: CachedNetworkImage(
                imageUrl: item.product.primaryImage.orPlaceholder,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: VCartColors.surface,
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: VCartColors.textSecondary,
                      size: 32,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: VCartColors.surface,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: VCartColors.textSecondary,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (item.product.hasDiscount)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: VCartColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${item.product.discountPercentage.toInt()}% OFF',
                  style: const TextStyle(
                    color: VCartColors.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: VCartColors.backgroundOpacity(0.7),
                  shape: BoxShape.circle,
                  border: Border.all(color: VCartColors.error, width: 2.0),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: VCartColors.error,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              VCartHelpers.truncateText(item.product.name, 30),
              style: const TextStyle(
                color: VCartColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              VCartHelpers.truncateText(item.product.description, 50),
              style: const TextStyle(
                color: VCartColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Wrap(
              spacing: 8,
              children: [
                Text(
                  item.product.finalOfferPrice.formatPrice,
                  style: const TextStyle(
                    color: VCartColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.product.hasDiscount)
                  Text(
                    item.product.finalPrice.formatPrice,
                    style: const TextStyle(
                      color: VCartColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
