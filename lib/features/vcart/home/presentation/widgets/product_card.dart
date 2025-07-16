import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:livera/features/vcart/core/utils/vcart_extensions.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onWishlistTap;
  final bool showWishlistButton;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onWishlistTap,
    this.showWishlistButton = true,
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
          children: [_buildImageSection(), _buildContentSection()],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
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
                imageUrl: product.primaryImage.orPlaceholder,
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
          if (product.hasDiscount)
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
                  '${product.discountPercentage.toInt()}% OFF',
                  style: const TextStyle(
                    color: VCartColors.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (showWishlistButton && onWishlistTap != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onWishlistTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: VCartColors.backgroundOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    product.isWishlisted
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: product.isWishlisted
                        ? VCartColors.error
                        : VCartColors.textPrimary,
                    size: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              VCartHelpers.truncateText(product.name, 30),
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
              VCartHelpers.truncateText(product.description, 50),
              style: const TextStyle(
                color: VCartColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  product.finalOfferPrice.formatPrice,
                  style: const TextStyle(
                    color: VCartColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (product.hasDiscount) ...[
                  const SizedBox(width: 8),
                  Text(
                    product.finalPrice.formatPrice,
                    style: const TextStyle(
                      color: VCartColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
