import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_grid.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';

class VCartHomePage extends StatelessWidget {
  const VCartHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VCartHomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: VCartColors.background,
          body: Obx(() {
            if (controller.hasError) {
              return VCartErrorWidget(
                message: controller.errorMessage,
                onRetry: () => controller.refreshData(),
              );
            }

            return Skeletonizer(
              enabled: controller.isLoading,
              child: CustomScrollView(
                slivers: [
                  VCartHomeAppBar(
                    onSearchTap: () => _navigateToSearch(),
                    onNotificationTap: () => _navigateToNotifications(),
                  ),
                  _buildCategoriesSection(controller),
                  _buildBannersSection(controller),
                  _buildPopularProductsSection(controller),
                  _buildTopBrandsSection(controller),
                  _buildTopSellingProductsSection(controller),
                  _buildBottomSpacing(),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildCategoriesSection(VCartHomeController controller) {
    if (controller.categories.isEmpty && !controller.isLoading) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return CategoryGrid(
      categories: controller.categories.cast(),
      onCategoryTap: (category) => _navigateToCategory(category),
    );
  }

  Widget _buildBannersSection(VCartHomeController controller) {
    if (controller.banners.isEmpty && !controller.isLoading) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: VCartConstants.defaultPadding,
        ),
        child: BannerCarousel(
          banners: controller.banners.cast(),
          onBannerTap: (banner) => _handleBannerTap(banner),
        ),
      ),
    );
  }

  Widget _buildPopularProductsSection(VCartHomeController controller) {
    if (controller.popularProducts.isEmpty && !controller.isLoading) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SectionHeader(
            title: 'Popular Products',
            onSeeAllTap: () => _navigateToProductListing('popular'),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: VCartConstants.defaultPadding,
              ),
              itemCount: controller.popularProducts.length,
              itemBuilder: (context, index) {
                final product = controller.popularProducts[index];
                return SizedBox(
                  width: 160,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: VCartConstants.smallPadding,
                    ),
                    child: ProductCard(
                      product: product,
                      onTap: () => _navigateToProductDetail(product.id),
                      onWishlistTap: () => _toggleWishlist(product, controller),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBrandsSection(VCartHomeController controller) {
    if (controller.topBrands.isEmpty && !controller.isLoading) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SectionHeader(
            title: 'Top Brands',
            onSeeAllTap: () => _navigateToProductListing('brands'),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: VCartConstants.defaultPadding,
              ),
              itemCount: controller.topBrands.length,
              itemBuilder: (context, index) {
                final brand = controller.topBrands[index];
                return _buildBrandItem(brand);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingProductsSection(VCartHomeController controller) {
    if (controller.topSellingProducts.isEmpty && !controller.isLoading) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          SectionHeader(
            title: 'Top Selling Products',
            onSeeAllTap: () => _navigateToProductListing('top-selling'),
          ),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: VCartConstants.defaultPadding,
              ),
              itemCount: controller.topSellingProducts.length,
              itemBuilder: (context, index) {
                final product = controller.topSellingProducts[index];
                return SizedBox(
                  width: 160,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: VCartConstants.smallPadding,
                    ),
                    child: ProductCard(
                      product: product,
                      onTap: () => _navigateToProductDetail(product.id),
                      onWishlistTap: () => _toggleWishlist(product, controller),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandItem(dynamic brand) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: VCartConstants.smallPadding),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
              border: Border.all(color: VCartColors.border),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
              child: Image.network(
                brand.imageUrl ?? VCartConstants.placeholderImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: VCartColors.surface,
                  child: const Icon(
                    Icons.store_outlined,
                    color: VCartColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            brand.name ?? '',
            style: const TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSpacing() {
    return const SliverToBoxAdapter(child: SizedBox(height: 100));
  }

  // Navigation methods
  void _navigateToSearch() {
    Get.toNamed('/search');
  }

  void _navigateToNotifications() {
    Get.toNamed('/notifications');
  }

  void _navigateToCategory(dynamic category) {
    Get.toNamed('/category', parameters: {'id': category.id});
  }

  void _navigateToProductDetail(String productId) {
    Get.toNamed('/product/$productId');
  }

  void _navigateToProductListing(String type) {
    Get.toNamed('/products', parameters: {'type': type});
  }

  void _handleBannerTap(dynamic banner) {
    switch (banner.field?.toLowerCase()) {
      case 'product':
        if (banner.productId != null) {
          _navigateToProductDetail(banner.productId!);
        }
        break;
      case 'category':
        if (banner.categoryId != null) {
          Get.toNamed('/category', parameters: {'id': banner.categoryId!});
        }
        break;
      case 'subcategory':
        if (banner.subCategoryId != null) {
          Get.toNamed(
            '/subcategory',
            parameters: {'id': banner.subCategoryId!},
          );
        }
        break;
      default:
        break;
    }
  }

  void _toggleWishlist(dynamic product, VCartHomeController controller) {
    final newWishlistState = !product.isWishlisted;
    controller.updateProductWishlistStatus(product.id, newWishlistState);
    controller.showVCartSnackBar(
      newWishlistState ? 'Added to wishlist' : 'Removed from wishlist',
    );
  }
}
