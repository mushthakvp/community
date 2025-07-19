import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/router/vcart_router.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/wishlist_controller.dart';
import '../widgets/wishlist_item_card.dart';

class VCartWishlistPage extends StatefulWidget {
  const VCartWishlistPage({super.key});

  @override
  State<VCartWishlistPage> createState() => _VCartWishlistPageState();
}

class _VCartWishlistPageState extends State<VCartWishlistPage> {
  final ScrollController _scrollController = ScrollController();
  late VCartWishlistController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VCartWishlistController>();
    controller.clearAllVariables();
    controller.getWishlistData();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!controller.isLoading && controller.hasMoreData) {
          controller.getWishlistData(isLoadMore: true);
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
    return WillPopScope(
      onWillPop: () async {
        VCartRouterG.backInVCart();
        return false;
      },
      child: Scaffold(
        backgroundColor: VCartColors.background,
        appBar: _buildAppBar(),
        body: GetBuilder<VCartWishlistController>(
          init: controller,
          builder: (controller) {
            return Obx(() {
              if (controller.hasError) {
                return VCartErrorWidget(
                  message: controller.errorMessage,
                  onRetry: () => controller.refreshData(),
                );
              }

              if (controller.wishlistItems.isEmpty && !controller.isLoading) {
                return const VCartMaintenanceWidget(
                  title: 'Your Wishlist is Empty',
                  subtitle:
                      'Browse our collection and add your favorites to keep track of them.',
                );
              }

              return Skeletonizer(
                enabled: controller.isLoading,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: context.defaultPadding,
                    child: Column(
                      children: [
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                childAspectRatio:
                                    VCartHelpers.calculateChildAspectRatio(
                                      context.screenWidth,
                                      context.screenHeight,
                                      multiplier: 0.25,
                                    ),
                              ),
                          itemCount: controller.wishlistItems.length,
                          itemBuilder: (context, index) {
                            final item = controller.wishlistItems[index];
                            return WishlistItemCard(
                              item: item,
                              onTap: () =>
                                  _navigateToProductDetail(item.product.id),
                              onRemove: () => controller.removeFromWishlist(
                                context,
                                item.product.id,
                                index,
                              ),
                            );
                          },
                        ),
                        if (controller.isLoading && controller.hasMoreData)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: VCartColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VCartColors.background,
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
          onPressed: () => VCartRouterG.backInVCart(),
        ),
      ),
      centerTitle: false,
      title: const Text(
        'Wishlist',
        style: TextStyle(
          fontSize: 18,
          color: VCartColors.textPrimary,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevation: 0,
    );
  }

  void _navigateToProductDetail(String productId) {
    VCartRouterG.toVCartProduct(productId);
  }
}
