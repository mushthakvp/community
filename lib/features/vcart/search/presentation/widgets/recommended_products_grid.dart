import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../domain/entities/recommended_product.dart';

class RecommendedProductsGrid extends StatelessWidget {
  final List<RecommendedProduct> products;
  final Function(RecommendedProduct) onProductTap;

  const RecommendedProductsGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: VCartHelpers.calculateChildAspectRatio(
          context.screenWidth,
          context.screenHeight,
          multiplier: 0.32,
        ),
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => onProductTap(product),
          child: _buildProductCard(product),
        );
      },
    );
  }

  Widget _buildProductCard(RecommendedProduct product) {
    return Container(
      decoration: BoxDecoration(
        color: VCartColors.cardBackground,
        borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
        border: Border.all(color: VCartColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImageSection(product), _buildContentSection(product)],
      ),
    );
  }

  Widget _buildImageSection(RecommendedProduct product) {
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
                  '${((product.price - product.offerPrice) / product.price * 100).toInt()}% OFF',
                  style: const TextStyle(
                    color: VCartColors.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection(RecommendedProduct product) {
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
            Text(
              product.finalOfferPrice.formatPrice,
              style: const TextStyle(
                color: VCartColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
