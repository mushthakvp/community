import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/product_listing_controller.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_search_bar.dart';
import '../widgets/sort_filter_bar.dart';

class VCartProductListingPage extends StatefulWidget {
  final String title;
  final String? sectionId;
  final String? categoryId;
  final String? subCategoryId;
  final String? brandId;

  const VCartProductListingPage({
    super.key,
    required this.title,
    this.sectionId,
    this.categoryId,
    this.subCategoryId,
    this.brandId,
  });

  @override
  State<VCartProductListingPage> createState() =>
      _VCartProductListingPageState();
}

class _VCartProductListingPageState extends State<VCartProductListingPage> {
  final ScrollController _scrollController = ScrollController();
  late VCartProductListingController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VCartProductListingController>();
    _initializeController();
    _setupScrollController();
  }

  void _initializeController() {
    controller.clearAllVariables();
    controller.setFilterParams(
      sectionId: widget.sectionId,
      categoryId: widget.categoryId,
      subCategoryId: widget.subCategoryId,
      brandId: widget.brandId,
    );
    controller.getProducts();
    controller.getFilteredProductCount();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!controller.isLoading && controller.hasMoreData) {
          controller.getProducts(isLoadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VCartColors.background,
      body: SafeArea(
        child: GetBuilder<VCartProductListingController>(
          init: controller,
          builder: (controller) {
            return Obx(() {
              if (controller.hasError) {
                return Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: VCartErrorWidget(
                        message: controller.errorMessage,
                        onRetry: () => controller.refreshProducts(),
                      ),
                    ),
                  ],
                );
              }

              if (controller.isPageDataEmpty) {
                return Column(
                  children: [
                    _buildAppBar(),
                    const Expanded(
                      child: VCartMaintenanceWidget(
                        title: 'No Products Found',
                        subtitle:
                            'Try adjusting your filters or search criteria.',
                      ),
                    ),
                  ],
                );
              }

              return Skeletonizer(
                enabled: controller.isLoading && controller.products.isEmpty,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: false,
                      leading: _buildBackButton(),
                      title: Text(
                        widget.title,
                        style: const TextStyle(
                          color: VCartColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      backgroundColor: VCartColors.background,
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickySearchDelegate(),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _StickyFilterDelegate(controller: controller),
                    ),
                    SliverPadding(
                      padding: context.defaultPadding,
                      sliver: ProductGrid(
                        products: controller.products,
                        onProductTap: (product) =>
                            _navigateToProductDetail(product.id),
                      ),
                    ),
                    if (controller.isLoading && controller.hasMoreData)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: VCartColors.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: VCartColors.background,
      child: Row(
        children: [
          _buildBackButton(),
          const SizedBox(width: 12),
          Text(
            widget.title,
            style: const TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: IconButton(
        icon: Container(
          decoration: BoxDecoration(
            border: Border.all(color: VCartColors.border.withOpacity(.1)),
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Icon(Icons.arrow_back, color: VCartColors.textPrimary),
          ),
        ),
        onPressed: () => VCartRouterClassG.backInVCart(),
      ),
    );
  }

  void _navigateToProductDetail(String productId) {
    VCartRouterClassG.toVCartProduct(productId);
  }
}

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: VCartColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const ProductSearchBar(),
    );
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _StickyFilterDelegate extends SliverPersistentHeaderDelegate {
  final VCartProductListingController controller;

  _StickyFilterDelegate({required this.controller});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: VCartColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SortFilterBar(controller: controller),
    );
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
