// lib/features/vcart/product_overview/presentation/widgets/product_details_section.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../controllers/product_overview_controller.dart';

class ProductDetailsSection extends StatelessWidget {
  final VCartProductOverviewController controller;

  const ProductDetailsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          SizedBox(height: screenHeight * 0.003),
          _buildProductName(),
          SizedBox(height: screenHeight * 0.003),
          _buildPriceRow(screenWidth),
          SizedBox(height: screenHeight * 0.01),
          if (controller.hasVariants) ...[
            _buildVariantsSection(screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.015),
          ],
          _buildSizesSection(screenWidth, screenHeight),
          SizedBox(height: screenHeight * 0.015),
          _buildDescriptionSection(screenHeight),
        ],
      );
    });
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            controller.productDetail?.brand.name ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: VCartColors.textPrimary,
              letterSpacing: 1,
            ),
          ),
        ),
        Obx(() {
          return Visibility(
            visible: controller.reviews.isNotEmpty,
            child: Row(
              children: [
                const Icon(Icons.star, color: VCartColors.warning),
                Skeletonizer(
                  enabled: controller.isReviewLoading,
                  child: Text(
                    "${controller.reviews.length}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: VCartColors.textPrimary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildProductName() {
    return Text(
      controller.productName,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: VCartColors.textPrimary,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceRow(double screenWidth) {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            text: "AED ${controller.finalOfferPrice.toStringAsFixed(2)} ",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: VCartColors.textPrimary,
            ),
            children: [
              if (controller.hasDiscount)
                TextSpan(
                  text: "AED ${controller.finalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: VCartColors.textPrimary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
        if (controller.discountPercentage > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: VCartConstants.smallPadding,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: VCartColors.primary,
              borderRadius: BorderRadius.circular(VCartConstants.largeRadius),
            ),
            child: Text(
              "${controller.discountPercentage.round()}% OFF",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: VCartColors.onPrimary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVariantsSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Color",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: VCartColors.textPrimary,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.productDetail?.variants.length ?? 0,
            itemBuilder: (context, index) {
              final variant = controller.productDetail!.variants[index];
              return Padding(
                padding: const EdgeInsets.only(
                  right: VCartConstants.smallPadding,
                ),
                child: InkWell(
                  onTap: () {
                    // Handle variant selection
                    controller.getProductDetail(variant.variantId);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      VCartConstants.defaultRadius,
                    ),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: VCartColors.border),
                      ),
                      child: variant.images.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: variant.images.first,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: VCartColors.surface,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: VCartColors.textSecondary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: VCartColors.surface,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: VCartColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              color: VCartColors.surface,
                              child: const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  color: VCartColors.textSecondary,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSizesSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Size",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: VCartColors.textPrimary,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.productSizes.length,
            itemBuilder: (context, index) {
              final size = controller.productSizes[index];
              final isSelected = controller.selectedSize?.id == size.id;

              return Padding(
                padding: const EdgeInsets.only(
                  right: VCartConstants.smallPadding,
                ),
                child: InkWell(
                  onTap: () => controller.selectSize(size),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: VCartConstants.defaultPadding,
                    ),
                    constraints: const BoxConstraints(minWidth: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        VCartConstants.defaultRadius,
                      ),
                      color: isSelected
                          ? VCartColors.primaryOpacity(0.5)
                          : VCartColors.surface,
                      border: Border.all(
                        color: isSelected
                            ? VCartColors.primary
                            : VCartColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        size.size.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? VCartColors.onPrimary
                              : VCartColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Description",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: VCartColors.textPrimary,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        FitReadMore(
          controller.productDescription,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: VCartColors.textSecondary,
          ),
          trimLength: 350,
          trimCollapsedText: 'Read more',
          trimExpandedText: 'Show less',
          colorClickableText: Colors.blue,
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }
}
