import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../domain/entities/search_product.dart';

class SearchProductGrid extends StatelessWidget {
  final List<SearchProduct> products;
  final Function(SearchProduct) onProductTap;

  const SearchProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7, // Fixed aspect ratio for better consistency
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

  Widget _buildProductCard(SearchProduct product) {
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

  Widget _buildImageSection(SearchProduct product) {
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
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: VCartColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${((product.price - product.offerPrice) / product.price * 100).toInt()}% OFF',
                  style: const TextStyle(
                    color: VCartColors.onPrimary,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContentSection(SearchProduct product) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            VCartHelpers.truncateText(product.name, 25),
            style: const TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Text(
              VCartHelpers.truncateText(product.description, 35),
              style: const TextStyle(
                color: VCartColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.finalOfferPrice.formatPrice,
                  style: const TextStyle(
                    color: VCartColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (product.hasDiscount) const SizedBox(width: 4),
              if (product.hasDiscount)
                Expanded(
                  child: Text(
                    product.finalPrice.formatPrice,
                    style: const TextStyle(
                      color: VCartColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
