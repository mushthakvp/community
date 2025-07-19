import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/image_widget.dart';
import '../../domain/entities/product_detail.dart';

class RelatedProductsSection extends StatelessWidget {
  final List<RelatedProduct> relatedProducts;
  final String currencyCode;
  final bool isPersonal;

  const RelatedProductsSection({
    super.key,
    required this.relatedProducts,
    required this.currencyCode,
    required this.isPersonal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Similar Ads',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: relatedProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = relatedProducts[index];
              return RelatedProductCard(
                product: product,
                currencyCode: currencyCode,
                onTap: () {
                  if (product.shareLink != null) {
                    context.push(
                      '/product-detail?shareUrl=${product.shareLink}&isPersonal=$isPersonal',
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class RelatedProductCard extends StatelessWidget {
  final RelatedProduct product;
  final String currencyCode;
  final VoidCallback onTap;

  const RelatedProductCard({
    super.key,
    required this.product,
    required this.currencyCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            CommonImageWidget(
              imageUrl: product.images.isNotEmpty ? product.images.first : null,
              width: 160,
              height: 120,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Brand
                  if (product.brand != null)
                    Text(
                      product.brand!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Price
                  Text(
                    '$currencyCode ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppConstants.appPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
