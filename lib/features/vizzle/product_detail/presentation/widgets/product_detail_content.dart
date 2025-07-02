import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/product_detail.dart';
import 'product_actions_section.dart';
import 'product_description_section.dart';
import 'product_image_gallery.dart';
import 'product_info_section.dart';
import 'product_location_section.dart';
import 'related_products_section.dart';
import 'seller_profile_section.dart';

class ProductDetailContent extends StatelessWidget {
  final ProductDetail product;
  final bool isPersonal;

  const ProductDetailContent({
    super.key,
    required this.product,
    required this.isPersonal,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: CustomScrollView(
        slivers: [
          ProductImageGallery(
            images: product.images,
            productId: product.id,
            isSaved: product.isSaved,
            isPersonal: isPersonal,
            shareLink: product.shareLink ?? '',
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductInfoSection(product: product),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 24),
                  if (!product.isCurrentUser && !isPersonal)
                    ProductActionsSection(product: product),
                  if (!product.isCurrentUser && !isPersonal)
                    const SizedBox(height: 24),
                  ProductDescriptionSection(description: product.description),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  if (!isPersonal) ...[
                    const SizedBox(height: 24),
                    ProductLocationSection(
                      address: product.address ?? '',
                      latitude: product.latitude,
                      longitude: product.longitude,
                    ),

                    const SizedBox(height: 24),
                    SellerProfileSection(
                      user: product.user,
                      sellerType: product.sellerType ?? '',
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 24),
                    _buildReportSection(context),
                    const SizedBox(height: 24),
                    if (product.relatedProducts.isNotEmpty)
                      RelatedProductsSection(
                        relatedProducts: product.relatedProducts,
                        currencyCode: product.currencyCode,
                        isPersonal: isPersonal,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSection(BuildContext context) {
    return Row(
      children: [
        Text(
          'Ad ID: ${product.id.substring(product.id.length - 8)}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            context.push(
              '/vizzle/report-product/${product.id}/${Uri.encodeComponent(product.title)}',
            );
          },
          child: const Row(
            children: [
              Icon(Icons.flag_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Report Ad',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
