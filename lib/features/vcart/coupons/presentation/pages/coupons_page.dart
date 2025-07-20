import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_text_field.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/coupons_controller.dart';
import '../widgets/coupon_item_widget.dart';

class VCartCouponsPage extends StatefulWidget {
  const VCartCouponsPage({super.key});

  @override
  State<VCartCouponsPage> createState() => _VCartCouponsPageState();
}

class _VCartCouponsPageState extends State<VCartCouponsPage> {
  late VCartCouponsController controller;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _couponCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeController();
    _setupScrollListener();
  }

  void _initializeController() {
    if (Get.isRegistered<VCartCouponsController>()) {
      controller = Get.find<VCartCouponsController>();
    } else {
      throw Exception('VCartCouponsController not registered');
    }
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !controller.isLoadingMore &&
          controller.hasMoreData) {
        controller.loadMoreCoupons();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _couponCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VCartColors.background,
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody()),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VCartColors.background,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: () => VCartRouterClassG.backInVCart(),
        icon: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            border: Border.all(color: VCartColors.border, width: 0.5),
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
        "Available Coupons",
        style: TextStyle(
          color: VCartColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (controller.hasError && controller.coupons.isEmpty) {
      return VCartErrorWidget(
        message: controller.errorMessage,
        onRetry: () => controller.refreshCoupons(),
      );
    }

    if (controller.isEmpty && !controller.isLoading) {
      return const VCartMaintenanceWidget(
        imageUrl:
            'https://res.cloudinary.com/fouvtycloud/image/upload/v1734067618/Coupen_mzujhy.gif',
        title: 'No Coupons Available',
        subtitle: 'Check back later for exciting offers and discounts!',
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshCoupons,
      color: VCartColors.primary,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: context.defaultPadding,
        child: Skeletonizer(
          enabled: controller.isLoading,
          child: Column(
            children: [
              _buildCouponCodeInput(),
              const SizedBox(height: 20),
              _buildCouponsList(),
              if (controller.isLoadingMore) _buildLoadMoreIndicator(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponCodeInput() {
    return VCartTextField(
      controller: _couponCodeController,
      hintText: "Enter Coupon Code",
      suffixIcon: GestureDetector(
        onTap: _onApplyCouponCode,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: VCartColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text(
              "APPLY",
              style: TextStyle(
                color: VCartColors.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.coupons.length,
      itemBuilder: (context, index) {
        return CouponItemWidget(
          coupon: controller.coupons[index],
          isApplied: controller.isCouponApplied(controller.coupons[index].id),
          isLoading:
              controller.isApplying &&
              controller.appliedCouponId == controller.coupons[index].id,
          onApply: () =>
              controller.applyCoupon(controller.coupons[index].id, context),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CircularProgressIndicator(
          color: VCartColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  void _onApplyCouponCode() {
    final code = _couponCodeController.text.trim();
    if (code.isNotEmpty) {
      context.showVCartSnackBar('Feature coming soon!');
    } else {
      context.showVCartSnackBar('Please enter a coupon code', isError: true);
    }
  }
}
