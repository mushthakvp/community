import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../controllers/prize_overview_controller.dart';
import '../widgets/prize_content_view.dart';
import '../widgets/prize_error_view.dart';
import '../widgets/prize_loading_view.dart';

class PrizeOverviewPage extends StatefulWidget {
  final String challengeId;

  const PrizeOverviewPage({super.key, required this.challengeId});

  @override
  State<PrizeOverviewPage> createState() => _PrizeOverviewPageState();
}

class _PrizeOverviewPageState extends State<PrizeOverviewPage> {
  late final PrizeOverviewController controller;
  late final String controllerTag;

  @override
  void initState() {
    super.initState();

    // Create unique controller tag
    controllerTag = 'prize_overview_${widget.challengeId}';

    // Remove existing controller if it exists
    if (Get.isRegistered<PrizeOverviewController>(tag: controllerTag)) {
      Get.delete<PrizeOverviewController>(tag: controllerTag);
    }

    // Initialize controller
    controller = Get.put(
      PrizeOverviewController(
        getPrizeOverviewUseCase: Get.find(tag: 'prize_overview'),
      ),
      tag: controllerTag,
    );

    // Load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPrizeOverview(widget.challengeId);
    });
  }

  @override
  void dispose() {
    // Clean up controller
    if (Get.isRegistered<PrizeOverviewController>(tag: controllerTag)) {
      Get.delete<PrizeOverviewController>(tag: controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: SafeArea(
        child: GetBuilder<PrizeOverviewController>(
          tag: controllerTag,
          builder: (controller) => Obx(() {
            if (controller.isLoading) {
              return const PrizeLoadingView();
            }

            if (controller.hasError) {
              return PrizeErrorView(
                errorMessage: controller.errorMessage,
                onRetry: () => controller.retryLoading(widget.challengeId),
                onGoBack: () => context.pop(),
              );
            }

            final prizeOverview = controller.prizeOverview;
            if (prizeOverview == null) {
              return _buildEmptyView();
            }

            return FadeTransition(
              opacity: controller.fadeInAnimation,
              child: PrizeContentView(
                prizeOverview: prizeOverview,
                confettiController: controller.confettiController,
                onNavigateToRecipe: controller.navigateToRecipeView,
                onGoBack: () => context.pop(),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.grey, size: 80),
          SizedBox(height: 20),
          Text(
            'No prize details available',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Please try refreshing the page',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
