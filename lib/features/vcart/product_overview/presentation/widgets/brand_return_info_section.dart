import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/product_overview_controller.dart';

class BrandReturnInfoSection extends StatelessWidget {
  final VCartProductOverviewController controller;

  const BrandReturnInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final brand = controller.productDetail?.brand;
    final productDetail = controller.productDetail;

    if (brand == null || productDetail == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.screenWidth * 0.02),
        color: VCartColors.primaryOpacity(0.2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: context.screenWidth * 0.06,
                  backgroundImage: CachedNetworkImageProvider(
                    brand.imageUrl.orPlaceholder,
                  ),
                  backgroundColor: VCartColors.surface,
                ),
                SizedBox(width: context.screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        brand.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: VCartColors.textPrimary,
                        ),
                      ),
                      Text(
                        brand.description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: VCartColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: VCartColors.textSecondary.withOpacity(0.1), height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
            child: Row(
              children: [
                Icon(
                  Icons.assignment_return_outlined,
                  size: context.screenHeight * 0.04,
                  color: VCartColors.textPrimary,
                ),
                SizedBox(width: context.screenWidth * 0.05),
                Text(
                  productDetail.isReturn
                      ? '${productDetail.returnDuration}-Day Return Available'
                      : "No Return Available",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: VCartColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
