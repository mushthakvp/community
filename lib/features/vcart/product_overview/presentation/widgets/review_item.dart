import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../domain/entities/review.dart';

class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.04,
        vertical: context.screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: VCartColors.surfaceOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: context.screenWidth * 0.06,
            backgroundImage: CachedNetworkImageProvider(
              review.user.profileImage.orPlaceholder,
            ),
            backgroundColor: VCartColors.surface,
          ),
          SizedBox(width: context.screenWidth * 0.05),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: VCartColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: VCartColors.warning),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: VCartColors.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.screenHeight * 0.01),
                Text(
                  DateFormat('MM/dd/yyyy').format(review.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: VCartColors.textSecondary,
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.01),
                Text(
                  review.reviewText,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
