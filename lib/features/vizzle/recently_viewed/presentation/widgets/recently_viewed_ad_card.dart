import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/image_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/recently_viewed_ad_entity.dart';

class RecentlyViewedAdCard extends StatelessWidget {
  final RecentlyViewedAdEntity ad;
  final bool isToggling;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const RecentlyViewedAdCard({
    super.key,
    required this.ad,
    required this.isToggling,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A1A),
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppConstants.white.withOpacity(0.1), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildImageSection(),
              const SizedBox(width: 12),
              Expanded(child: _buildContentSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppConstants.white.withOpacity(0.05),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ad.primaryImage.isNotEmpty
                ? CommonImageWidget(
                    imageUrl: ad.primaryImage,
                    width: 100,
                    height: 96,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppConstants.white.withOpacity(0.1),
                    child: Icon(
                      Icons.image_outlined,
                      color: AppConstants.white.withOpacity(0.5),
                      size: 32,
                    ),
                  ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onToggleFavorite,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppConstants.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isToggling
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.appPrimaryColor,
                        ),
                      ),
                    )
                  : Icon(
                      ad.isSaved ? Icons.favorite : Icons.favorite_border,
                      color: ad.isSaved
                          ? AppConstants.appPrimaryColor
                          : AppConstants.white.withOpacity(0.7),
                      size: 16,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildTopSection(), _buildBottomSection()],
    );
  }

  Widget _buildTopSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CommonTextWidget(
                text: ad.formattedPrice,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppConstants.appPrimaryColor,
                maxLines: 1,
              ),
            ),
            CommonTextWidget(
              text: ad.timeAgo,
              fontSize: 11,
              color: AppConstants.white.withOpacity(0.5),
            ),
          ],
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: ad.title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.white,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ad.year != null) ...[
          CommonTextWidget(
            text: ad.ageDisplay,
            fontSize: 12,
            color: AppConstants.white.withOpacity(0.7),
            maxLines: 1,
          ),
          const SizedBox(height: 2),
        ],
        if (ad.brandModel.isNotEmpty) ...[
          CommonTextWidget(
            text: 'Brand: ${ad.brandModel}',
            fontSize: 12,
            color: AppConstants.white.withOpacity(0.7),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
        ],
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppConstants.appPrimaryColor,
              size: 12,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: CommonTextWidget(
                text: ad.district,
                fontSize: 11,
                color: AppConstants.white.withOpacity(0.6),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
