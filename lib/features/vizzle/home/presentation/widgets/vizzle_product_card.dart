import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';

class VizzleProductCard extends StatelessWidget {
  final AdEntity product;
  final String section;
  final String currencyCode;

  const VizzleProductCard({
    super.key,
    required this.product,
    required this.section,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '${RouteConstants.vizzleProductDetails}/${product.id}',
          extra: {'shareUrl': product.shareLink},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildProductImage()),
            _buildProductInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        child: product.hasValidImage
            ? CachedNetworkImage(
                imageUrl: product.primaryImage,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppConstants.white.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.appPrimaryColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildErrorImage(),
              )
            : _buildErrorImage(),
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: AppConstants.white.withOpacity(0.1),
      child: Icon(
        Icons.image_not_supported,
        color: AppConstants.white.withOpacity(0.5),
        size: 40,
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextWidget(
            text: '$currencyCode ${product.formattedPrice}',
            color: AppConstants.appPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 4),
          CommonTextWidget(
            text: product.displayTitle,
            color: AppConstants.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          CommonTextWidget(
            text: section == "motors"
                ? "${product.year}, ${product.kilometers} km"
                : product.brand ?? "",
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w300,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
