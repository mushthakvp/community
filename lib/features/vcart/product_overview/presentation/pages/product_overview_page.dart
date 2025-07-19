import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/router/vcart_router.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../controllers/product_overview_controller.dart';
import '../widgets/brand_return_info_section.dart';
import '../widgets/floating_bottom_sheet.dart';
import '../widgets/product_details_section.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_tabs_section.dart';
import '../widgets/reviews_section.dart';

class VCartProductOverviewPage extends StatefulWidget {
  final String productId;

  const VCartProductOverviewPage({super.key, required this.productId});

  @override
  State<VCartProductOverviewPage> createState() =>
      _VCartProductOverviewPageState();
}

class _VCartProductOverviewPageState extends State<VCartProductOverviewPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomSheet = false;
  bool _showAppBar = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _setupScrollListener();
    _setupAnimations();
  }

  void _initializeController() {
    final controller = Get.find<VCartProductOverviewController>();
    controller.initialize(widget.productId);
  }

  void _setupScrollListener() {
    _scrollController.addListener(_onScroll);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final carouselHeight = context.screenHeight * 0.4;
    final appBarHeight = context.screenHeight * 0.1;

    final shouldShowBottomSheet = _scrollController.offset > carouselHeight;
    final shouldShowAppBar = _scrollController.offset > appBarHeight;

    if (shouldShowBottomSheet != _showBottomSheet) {
      setState(() {
        _showBottomSheet = shouldShowBottomSheet;
        if (shouldShowBottomSheet) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }

    if (shouldShowAppBar != _showAppBar) {
      setState(() {
        _showAppBar = shouldShowAppBar;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VCartProductOverviewController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            _handleBackPress();
            return false;
          },
          child: Scaffold(
            backgroundColor: VCartColors.background,
            body: Obx(() {
              if (controller.hasError) {
                return VCartErrorWidget(
                  message: controller.errorMessage,
                  onRetry: () => controller.refreshData(widget.productId),
                );
              }
              return Skeletonizer(
                enabled: controller.isLoading,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductImageCarousel(controller: controller),
                          Padding(
                            padding: context.defaultPadding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductDetailsSection(controller: controller),
                                SizedBox(height: context.screenHeight * 0.01),
                                ProductTabsSection(controller: controller),
                                SizedBox(height: context.screenHeight * 0.02),
                                BrandReturnInfoSection(controller: controller),
                                SizedBox(height: context.screenHeight * 0.01),
                                ReviewsSection(
                                  controller: controller,
                                  productId: widget.productId,
                                ),
                                SizedBox(height: context.screenHeight * 0.15),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildAppBar(),
                  ],
                ),
              );
            }),
            bottomSheet: _showBottomSheet
                ? FloatingBottomSheet(
                    controller: controller,
                    animation: _slideAnimation,
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Visibility(
      visible: !_showAppBar,
      child: SafeArea(
        child: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: VCartColors.backgroundOpacity(0.7),
              shape: BoxShape.circle,
              border: Border.all(color: VCartColors.border, width: 2),
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16,
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: VCartColors.textPrimary,
              ),
            ),
          ),
          onPressed: _handleBackPress,
        ),
      ),
    );
  }

  void _handleBackPress() {
    final currentRoute = Get.currentRoute;
    if (currentRoute.startsWith('/vcart') || currentRoute.contains('product')) {
      VCartRouter.backToVCartHome();
    } else {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        VCartRouter.backToVCartHome();
      }
    }
  }
}
