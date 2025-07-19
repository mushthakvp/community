import 'package:flutter/material.dart';

import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../../home/presentation/widgets/product_card.dart';
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
          child: ProductCard(
            product: _convertToProductEntity(product),
            onTap: () => onProductTap(product),
            showWishlistButton: false,
          ),
        );
      },
    );
  }

  // Helper method to convert RecommendedProduct to Product entity for ProductCard
  dynamic _convertToProductEntity(RecommendedProduct product) {
    return _ProductAdapter(product);
  }
}

// Adapter class to make RecommendedProduct compatible with ProductCard
class _ProductAdapter {
  final RecommendedProduct _product;

  _ProductAdapter(this._product);

  String get id => _product.id;
  String get name => _product.name;
  String get description => _product.description;
  List<String> get images => _product.images;
  double get price => _product.price;
  double get offerPrice => _product.offerPrice;
  double get commission => _product.commission;
  double get finalPrice => _product.finalPrice;
  double get finalOfferPrice => _product.finalOfferPrice;
  bool get hasDiscount => _product.hasDiscount;
  String get primaryImage => _product.primaryImage;
  bool get isWishlisted => false;
}
