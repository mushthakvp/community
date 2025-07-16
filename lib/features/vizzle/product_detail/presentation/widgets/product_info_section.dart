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

        // Product Details - Show only non-null values
        ..._buildDetailsList(),

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

  List<Widget> _buildDetailsList() {
    List<Widget> detailWidgets = [];

    // Product ID (always show last 8 characters for reference)
    detailWidgets.add(
      _buildDetailRow(
        'Ad ID',
        product.id.length > 8
            ? product.id.substring(product.id.length - 8)
            : product.id,
      ),
    );

    // Category
    if (product.category != null && product.category!.name.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Category', product.category!.name));
    }

    // Sub Category
    if (product.subCategory != null && product.subCategory!.name.isNotEmpty) {
      detailWidgets.add(
        _buildDetailRow('Sub Category', product.subCategory!.name),
      );
    }

    // Brand
    if (product.brand != null && product.brand!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Brand', product.brand!));
    }

    // Model
    if (product.model != null && product.model!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Model', product.model!));
    }

    // Color
    if (product.color != null && product.color!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Color', product.color!));
    }

    // Age
    if (product.age != null && product.age!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Age', product.age!));
    }

    // Usage
    if (product.usage != null && product.usage!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Usage', product.usage!));
    }

    // Condition
    if (product.condition != null && product.condition!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Condition', product.condition!));
    }

    // Seller Type
    if (product.sellerType != null && product.sellerType!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Seller Type', product.sellerType!));
    }

    // Phone
    if (product.phone != null && product.phone!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Phone', product.phone!));
    }

    // Address
    if (product.address != null && product.address!.isNotEmpty) {
      detailWidgets.add(_buildDetailRow('Location', product.address!));
    }

    // User Info
    detailWidgets.add(_buildDetailRow('Seller Name', product.user.name));

    // User ID (last 8 characters for reference)
    detailWidgets.add(
      _buildDetailRow(
        'Seller ID',
        product.user.id.length > 8
            ? product.user.id.substring(product.user.id.length - 8)
            : product.user.id,
      ),
    );

    return detailWidgets;
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
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
