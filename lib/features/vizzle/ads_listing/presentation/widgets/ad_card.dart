import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/ad_entity.dart';

enum AdCardType { grid, list }

class AdCard extends StatelessWidget {
  final AdEntity ad;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final AdCardType cardType;

  const AdCard({
    super.key,
    required this.ad,
    required this.onTap,
    required this.onFavoriteTap,
    required this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: cardType == AdCardType.grid
            ? _buildGridCard()
            : _buildListCard(),
      ),
    );
  }

  Widget _buildGridCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildImageSection()),
        Expanded(flex: 2, child: _buildInfoSection()),
      ],
    );
  }

  Widget _buildListCard() {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          SizedBox(width: 120, child: _buildImageSection()),
          Expanded(child: _buildInfoSection()),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: cardType == AdCardType.grid
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
          ),
          child: ClipRRect(
            borderRadius: cardType == AdCardType.grid
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
            child: ad.hasImages
                ? CachedNetworkImage(
                    imageUrl: ad.primaryImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildImagePlaceholder(),
                    errorWidget: (context, url, error) => _buildImageError(),
                  )
                : _buildImageError(),
          ),
        ),

        // Featured badge
        if (ad.isFeatured)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const CommonTextWidget(
                text: 'Featured',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppConstants.black,
              ),
            ),
          ),

        // Favorite button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onFavoriteTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                ad.isSaved ? Icons.favorite : Icons.favorite_border,
                color: ad.isSaved ? Colors.red : AppConstants.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price
              CommonTextWidget(
                text: ad.formattedPrice,
                color: AppConstants.appPrimaryColor,
                fontSize: cardType == AdCardType.grid ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),

              const SizedBox(height: 4),

              // Title
              CommonTextWidget(
                text: ad.displayTitle,
                color: AppConstants.white,
                fontSize: cardType == AdCardType.grid ? 12 : 14,
                fontWeight: FontWeight.w500,
                maxLines: cardType == AdCardType.grid ? 2 : 1,
              ),

              if (cardType == AdCardType.list) ...[
                const SizedBox(height: 4),
                // Additional info for list view
                if (ad.isMotorAd && ad.vehicleInfo != null)
                  CommonTextWidget(
                    text: ad.vehicleInfo!.displayInfo,
                    color: AppConstants.white.withOpacity(0.6),
                    fontSize: 12,
                    maxLines: 1,
                  )
                else if (ad.isPropertyAd && ad.propertyInfo != null)
                  CommonTextWidget(
                    text: ad.propertyInfo!.displayInfo,
                    color: AppConstants.white.withOpacity(0.6),
                    fontSize: 12,
                    maxLines: 1,
                  ),
              ],
            ],
          ),

          // Location and time
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppConstants.white.withOpacity(0.6),
                size: 12,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CommonTextWidget(
                  text: ad.location,
                  color: AppConstants.white.withOpacity(0.6),
                  fontSize: 10,
                  maxLines: 1,
                ),
              ),
              CommonTextWidget(
                text: ad.timeAgo,
                color: AppConstants.white.withOpacity(0.6),
                fontSize: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppConstants.white.withOpacity(0.1),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppConstants.appPrimaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: AppConstants.white.withOpacity(0.1),
      child: Icon(
        Icons.image_not_supported,
        color: AppConstants.white.withOpacity(0.5),
        size: cardType == AdCardType.grid ? 32 : 24,
      ),
    );
  }
}
