import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/vizzle_entities.dart';
import 'vizzle_product_card.dart';

class VizzleProductGrid extends StatelessWidget {
  final List<AdEntity> products;
  final String section;
  final String currencyCode;

  const VizzleProductGrid({
    super.key,
    required this.products,
    required this.section,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];
          return VizzleProductCard(
            product: product,
            section: section,
            currencyCode: currencyCode,
          );
        }, childCount: products.length),
      ),
    );
  }
}
