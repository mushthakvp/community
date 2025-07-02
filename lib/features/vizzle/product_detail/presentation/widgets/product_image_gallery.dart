import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/image_widget.dart';
import '../providers/product_detail_provider.dart';

class ProductImageGallery extends StatelessWidget {
  final List<String> images;
  final String productId;
  final bool isSaved;
  final bool isPersonal;
  final String shareLink;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.productId,
    required this.isSaved,
    required this.isPersonal,
    required this.shareLink,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          // Image PageView
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              context.read<ProductDetailProvider>().updateImageIndex(index);
            },
            itemBuilder: (context, index) {
              return CommonImageWidget(
                imageUrl: images[index],
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              );
            },
          ),

          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppConstants.appPrimaryColor,
                  size: 20,
                ),
              ),
            ),
          ),

          // Action Buttons (Save & Share)
          Positioned(
            top: 40,
            right: 16,
            child: Row(
              children: [
                // Share Button
                Consumer<ProductDetailProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: AppConstants.appPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: provider.isShareLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : IconButton(
                              onPressed: provider.shareProduct,
                              icon: const Icon(
                                Icons.share,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                    );
                  },
                ),

                if (!isPersonal) ...[
                  const SizedBox(width: 12),

                  // Favorite Button
                  Consumer<ProductDetailProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppConstants.appPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: provider.isFavoriteLoading
                            ? const Padding(
                                padding: EdgeInsets.all(8),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : IconButton(
                                onPressed: provider.toggleFavorite,
                                icon: Icon(
                                  isSaved
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),

          // Image Indicator
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Image Counter
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Consumer<ProductDetailProvider>(
                    builder: (context, provider, child) {
                      return Text(
                        '${provider.currentImageIndex + 1}/${images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),

                // Dots Indicator
                if (images.length > 1)
                  Consumer<ProductDetailProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: provider.currentImageIndex == index
                                  ? AppConstants.appPrimaryColor
                                  : Colors.white54,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
