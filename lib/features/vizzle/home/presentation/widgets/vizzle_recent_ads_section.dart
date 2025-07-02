import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';

class VizzleRecentAdsSection extends StatelessWidget {
  final VizzleHomeEntity vizzleHome;

  const VizzleRecentAdsSection({super.key, required this.vizzleHome});

  @override
  Widget build(BuildContext context) {
    final recentAds = _getRecentAds();

    if (recentAds.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final ad = recentAds[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _RecentAdCard(
              ad: ad,
              currencyCode: vizzleHome.currencyCode,
              onTap: () {
                // Fixed navigation - use the correct route format
                context.push(
                  '${RouteConstants.productDetail}?shareUrl=${Uri.encodeComponent(ad.shareLink)}&isPersonal=false',
                );
              },
            ),
          );
        }, childCount: recentAds.length > 5 ? 5 : recentAds.length),
      ),
    );
  }

  List<AdEntity> _getRecentAds() {
    final allAds = [
      ...vizzleHome.motors,
      ...vizzleHome.classifieds,
      ...vizzleHome.furnitureGarden,
      ...vizzleHome.propertyForSale,
    ];

    // Return first 5 ads as "recent"
    return allAds.take(5).toList();
  }
}

class _RecentAdCard extends StatelessWidget {
  final AdEntity ad;
  final String currencyCode;
  final VoidCallback onTap;

  const _RecentAdCard({
    required this.ad,
    required this.currencyCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Image Section
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: ad.hasValidImage
                      ? CachedNetworkImage(
                          imageUrl: ad.primaryImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _buildImagePlaceholder(),
                          errorWidget: (context, url, error) =>
                              _buildImageError(),
                        )
                      : _buildImageError(),
                ),
              ),

              // Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      CommonTextWidget(
                        text: '$currencyCode ${ad.formattedPrice}',
                        color: AppConstants.appPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 4),

                      // Title
                      CommonTextWidget(
                        text: ad.displayTitle,
                        color: AppConstants.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        maxLines: 2,
                      ),

                      const Spacer(),

                      // Additional Info Row
                      Row(
                        children: [
                          // Category or additional info
                          if (ad.isMotorAd) ...[
                            Expanded(
                              child: CommonTextWidget(
                                text: '${ad.year} • ${ad.kilometers} km',
                                color: AppConstants.white.withOpacity(0.6),
                                fontSize: 12,
                                maxLines: 1,
                              ),
                            ),
                          ] else if (ad.brand != null &&
                              ad.brand!.isNotEmpty) ...[
                            Expanded(
                              child: CommonTextWidget(
                                text: ad.brand!,
                                color: AppConstants.white.withOpacity(0.6),
                                fontSize: 12,
                                maxLines: 1,
                              ),
                            ),
                          ] else ...[
                            const Expanded(child: SizedBox()),
                          ],

                          // Arrow indicator
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppConstants.white.withOpacity(0.4),
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
        size: 32,
      ),
    );
  }
}
