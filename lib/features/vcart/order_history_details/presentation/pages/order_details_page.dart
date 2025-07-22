import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_button.dart';
import '../../../core/widgets/vcart_loading.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../controllers/order_details_controller.dart';
import '../widgets/order_details_header_widget.dart';
import '../widgets/order_details_summary_widget.dart';
import '../widgets/order_shipping_address_widget.dart';
import '../widgets/order_tracking_widget.dart';
import '../widgets/review_dialog.dart';

class VCartOrderDetailsPage extends StatelessWidget {
  final String orderId;

  const VCartOrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VCartOrderDetailsController>();

    // Load order details when page builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadOrderDetails(orderId);
    });

    return Scaffold(
      backgroundColor: VCartColors.background,
      appBar: _buildAppBar(context),
      body: Obx(() => _buildBody(context, controller)),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: VCartColors.background,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            border: Border.all(color: VCartColors.border, width: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back,
            size: 18,
            color: VCartColors.textPrimary,
          ),
        ),
      ),
      title: const Text(
        "Order Details",
        style: TextStyle(
          color: VCartColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    VCartOrderDetailsController controller,
  ) {
    if (controller.isLoading) {
      return const Center(child: VCartLoading(size: 32));
    }

    if (controller.hasError) {
      return VCartErrorWidget(
        message: controller.errorMessage,
        onRetry: () => controller.loadOrderDetails(orderId),
      );
    }

    if (controller.orderDetails == null) {
      return const Center(
        child: Text(
          'Order not found',
          style: TextStyle(color: VCartColors.textSecondary, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      padding: context.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderDetailsHeaderWidget(controller: controller),
          const SizedBox(height: 24),
          OrderDetailsSummaryWidget(controller: controller),
          const SizedBox(height: 24),
          OrderTrackingWidget(controller: controller),
          const SizedBox(height: 24),
          OrderShippingAddressWidget(controller: controller),
          const SizedBox(height: 24),
          if (controller.canSubmitReview) ...[
            _buildReviewSection(context, controller),
            const SizedBox(height: 24),
          ],
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildReviewSection(
    BuildContext context,
    VCartOrderDetailsController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rate & Review",
          style: TextStyle(
            color: VCartColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        VCartButton(
          text: "Rate this Order",
          icon: Icons.star_outline,
          onPressed: () => _showReviewDialog(context, controller),
          isExpanded: true,
        ),
      ],
    );
  }

  void _showReviewDialog(
    BuildContext context,
    VCartOrderDetailsController controller,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReviewDialog(controller: controller),
    );
  }
}
