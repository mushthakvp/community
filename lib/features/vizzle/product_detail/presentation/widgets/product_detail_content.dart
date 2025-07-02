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
      onRefresh: () async {
        // Implement refresh logic
      },
      child: CustomScrollView(
        slivers: [
          // Image Gallery
          SliverToBoxAdapter(
            child: ProductImageGallery(
              images: product.images,
              productId: product.id,
              isSaved: product.isSaved,
              isPersonal: isPersonal,
              shareLink: product.shareLink ?? '',
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Info
                  ProductInfoSection(product: product),

                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 24),

                  // Actions (Chat, Call, WhatsApp)
                  if (!product.isCurrentUser && !isPersonal)
                    ProductActionsSection(product: product),

                  if (!product.isCurrentUser && !isPersonal)
                    const SizedBox(height: 24),

                  // Description
                  ProductDescriptionSection(description: product.description),

                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),

                  // Location (only if not personal)
                  if (!isPersonal) ...[
                    const SizedBox(height: 24),
                    ProductLocationSection(
                      address: product.address ?? '',
                      latitude: product.latitude,
                      longitude: product.longitude,
                    ),

                    const SizedBox(height: 24),

                    // Seller Profile
                    SellerProfileSection(
                      user: product.user,
                      sellerType: product.sellerType ?? '',
                    ),

                    const SizedBox(height: 24),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 24),

                    // Report Ad Section
                    _buildReportSection(context),

                    const SizedBox(height: 24),

                    // Related Products
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
            // Navigate to report page
            context.go('/report-product?productId=${product.id}&title=Ad');
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
