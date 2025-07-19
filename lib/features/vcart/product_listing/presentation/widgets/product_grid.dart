import 'package:flutter/material.dart';

import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../domain/entities/product_listing_item.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductListingItem> products;
  final Function(ProductListingItem) onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: VCartHelpers.calculateChildAspectRatio(
          context.screenWidth,
          context.screenHeight,
          multiplier: 0.26,
        ),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => onProductTap(product),
        );
      }, childCount: products.length),
    );
  }
}
