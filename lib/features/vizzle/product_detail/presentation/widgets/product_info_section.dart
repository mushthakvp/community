import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/product_detail.dart';
import '../providers/product_detail_provider.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductDetail product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Price
        Text(
          '${product.currencyCode} ${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppConstants.appPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        // Title
        Text(
          product.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 16),
        const Divider(color: Colors.white24),
        const SizedBox(height: 16),

        // Details Header
        const Text(
          'Details',
          style: TextStyle(
            color: AppConstants.appPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 16),

        // Product Details
        if (product.age != null) _buildDetailRow('Age', product.age!),
        if (product.usage != null) _buildDetailRow('Usage', product.usage!),
        if (product.condition != null)
          _buildDetailRow('Condition', product.condition!),
        if (product.sellerType != null)
          _buildDetailRow('Seller Type', product.sellerType!),
        if (product.brand != null) _buildDetailRow('Brand', product.brand!),
        if (product.model != null) _buildDetailRow('Model', product.model!),
        if (product.color != null) _buildDetailRow('Color', product.color!),

        // Posted Date
        Consumer<ProductDetailProvider>(
          builder: (context, provider, child) {
            return _buildDetailRow(
              'Posted on',
              provider.calculateTimeAgo(product.createdAt),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
