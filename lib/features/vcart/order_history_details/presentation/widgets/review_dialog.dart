import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/widgets/vcart_button.dart';
import '../../../core/widgets/vcart_text_field.dart';
import '../controllers/order_details_controller.dart';

class ReviewDialog extends StatelessWidget {
  final VCartOrderDetailsController controller;

  const ReviewDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: VCartColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildRatingSection(),
            const SizedBox(height: 24),
            _buildReviewSection(),
            const SizedBox(height: 24),
            _buildImageSection(),
            const SizedBox(height: 32),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Rate & Review',
          style: TextStyle(
            color: VCartColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.close,
            color: VCartColors.textSecondary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rating",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: VCartColors.textSecondary.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => controller.setRating((index + 1).toDouble()),
                  child: Icon(
                    index < controller.rating ? Icons.star : Icons.star_border,
                    color: index < controller.rating
                        ? VCartColors.warning
                        : VCartColors.textSecondary,
                    size: 32,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Review",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: VCartColors.textSecondary.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        VCartTextField(
          controller: controller.reviewController,
          hintText: 'Write your review here...',
          maxLines: 4,
          maxLength: 500,
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Photos (Optional)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: VCartColors.textSecondary.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.reviewImages.isEmpty) {
            return _buildAddImageButton();
          }

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...controller.reviewImages.asMap().entries.map(
                (entry) => _buildImageTile(entry.key, entry.value),
              ),
              if (controller.reviewImages.length < 5) _buildAddImageButton(),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () {
        // In a real implementation, you would use image_picker here
        // For now, we'll just add a placeholder
        controller.addReviewImage('https://via.placeholder.com/100x100');
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: VCartColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: VCartColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: const Icon(
          Icons.add_photo_alternate_outlined,
          color: VCartColors.textSecondary,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildImageTile(int index, String imageUrl) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => controller.removeReviewImage(index),
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: VCartColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: VCartColors.onPrimary,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VCartButton(
            text: "Cancel",
            type: VCartButtonType.secondary,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(
            () => VCartButton(
              text: "Submit",
              onPressed: () async {
                await controller.submitOrderReview(context);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              isLoading: controller.isSubmittingReview,
            ),
          ),
        ),
      ],
    );
  }
}
