import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/product_overview_controller.dart';
import 'review_item.dart';

class ReviewsSection extends StatelessWidget {
  final VCartProductOverviewController controller;
  final String productId;

  const ReviewsSection({
    super.key,
    required this.controller,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Skeletonizer(
        enabled: controller.isReviewLoading,
        enableSwitchAnimation: controller.isReviewLoading,
        child: controller.isReviewsEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 10),
                  _buildRatingOverview(context),
                  SizedBox(height: context.screenHeight * 0.02),
                  if (controller.reviews.isNotEmpty)
                    ReviewItem(review: controller.reviews.first),
                ],
              ),
      );
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Reviews",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: VCartColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (controller.reviews.length > 1)
          TextButton(
            onPressed: () => _navigateToAllReviews(context),
            child: const Text(
              "See All",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: VCartColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingOverview(BuildContext context) {
    final averageRating = controller.productOverviewData?.averageRating ?? 0.0;
    final totalReviews = controller.reviews.length;

    return Container(
      decoration: BoxDecoration(
        color: VCartColors.surfaceOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.04,
        vertical: context.screenHeight * 0.02,
      ),
      child: Row(
        children: [
          _buildStarRating(averageRating),
          SizedBox(width: context.screenWidth * 0.01),
          Text(
            "${averageRating.toStringAsFixed(1)} ($totalReviews Reviews)",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: VCartColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, color: VCartColors.warning, size: 25);
        } else if (index < rating) {
          return const Icon(
            Icons.star_half,
            color: VCartColors.warning,
            size: 25,
          );
        } else {
          return const Icon(
            Icons.star_border,
            color: VCartColors.warning,
            size: 25,
          );
        }
      }),
    );
  }

  void _navigateToAllReviews(BuildContext context) {
    Get.toNamed('/reviews', parameters: {'productId': productId});
  }
}
