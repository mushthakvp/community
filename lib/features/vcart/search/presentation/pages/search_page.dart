import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/router/vcart_router.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/search_controller.dart';
import '../widgets/recommended_products_grid.dart';
import '../widgets/search_field.dart';
import '../widgets/search_product_grid.dart';
import '../widgets/sections_grid.dart';

class VCartSearchPage extends StatefulWidget {
  const VCartSearchPage({super.key});

  @override
  State<VCartSearchPage> createState() => _VCartSearchPageState();
}

class _VCartSearchPageState extends State<VCartSearchPage>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  late VCartSearchController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<VCartSearchController>();
    _setupScrollController();

    // Override system back button for this page
    _setupSystemBackHandler();
  }

  void _setupSystemBackHandler() {
    // Listen for system back button
    SystemChannels.navigation.setMethodCallHandler((call) async {
      if (call.method == 'routePopped') {
        debugPrint('🔙 Search Page: System back detected via SystemChannels');
        VCartRouterG.backInVCart();
        return true;
      }
      return null;
    });
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (controller.isSearched) {
          controller.loadMoreSearchResults();
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    // Reset system channel handler
    SystemChannels.navigation.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('🔄 Search Page: App lifecycle state changed to $state');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          debugPrint('🔙 Search Page: PopScope system back pressed');
          VCartRouterG.backInVCart();
        }
      },
      child: Scaffold(
        backgroundColor: VCartColors.background,
        body: GetBuilder<VCartSearchController>(
          init: controller,
          builder: (controller) {
            return Obx(() {
              if (controller.hasError) {
                return VCartErrorWidget(
                  message: controller.errorMessage,
                  onRetry: () => controller.refreshData(),
                );
              }

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: context.defaultPadding,
                      child: controller.isSearched
                          ? _buildSearchResults()
                          : _buildSearchHome(),
                    ),
                  ),
                ],
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: VCartColors.background,
      pinned: true,
      floating: true,
      expandedHeight: 120.0,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(color: VCartColors.border),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              child: Icon(Icons.arrow_back, color: VCartColors.textPrimary),
            ),
          ),
          onPressed: () {
            debugPrint('🔙 Search Page: App bar back pressed');
            VCartRouterG.backInVCart();
          },
        ),
      ),
      title: const Text(
        'Search',
        style: TextStyle(
          fontSize: 18,
          color: VCartColors.textPrimary,
          fontWeight: FontWeight.w400,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: SearchField(controller: controller),
      ),
    );
  }

  Widget _buildSearchHome() {
    return Obx(() {
      return Skeletonizer(
        enabled: controller.isLoading,
        child: controller.isLoading
            ? _buildLoadingSkeleton()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.sections.isNotEmpty) ...[
                    _buildSectionHeader('Popular Search'),
                    const SizedBox(height: 20),
                    SectionsGrid(
                      sections: controller.sections,
                      onSectionTap: (section) => _navigateToSection(section.id),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (controller.recommended.isNotEmpty) ...[
                    _buildSectionHeader('Recommended For You'),
                    const SizedBox(height: 20),
                    RecommendedProductsGrid(
                      products: controller.recommended,
                      onProductTap: (product) => _navigateToProduct(product.id),
                    ),
                  ],
                ],
              ),
      );
    });
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (controller.searchProducts.isEmpty && !controller.isSearchLoading) {
        return const VCartMaintenanceWidget(
          title: 'No Results Found',
          subtitle: 'Try searching with different keywords.',
        );
      }

      return Skeletonizer(
        enabled:
            controller.isSearchLoading && controller.searchProducts.isEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.searchProducts.isNotEmpty) ...[
              Text(
                'Search Results (${controller.searchProducts.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: VCartColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
            ],
            SearchProductGrid(
              products: controller.searchProducts,
              onProductTap: (product) => _navigateToProduct(product.id),
            ),
            if (controller.isSearchLoading && controller.hasMoreData)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(color: VCartColors.primary),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Popular Search'),
        const SizedBox(height: 20),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: VCartHelpers.calculateChildAspectRatio(
              context.screenWidth,
              context.screenHeight,
              multiplier: 1.5,
            ),
          ),
          itemCount: 4,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: VCartColors.surface,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionHeader('Recommended For You'),
        const SizedBox(height: 20),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: VCartHelpers.calculateChildAspectRatio(
              context.screenWidth,
              context.screenHeight,
              multiplier: 0.32,
            ),
          ),
          itemCount: 4,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: VCartColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        color: VCartColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _navigateToSection(String sectionId) {
    VCartRouterG.toVCartCategory(sectionId);
  }

  void _navigateToProduct(String productId) {
    VCartRouterG.toVCartProduct(productId);
  }
}
