import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../controllers/filter_page_controller.dart';
import '../widgets/filter_content.dart';
import '../widgets/filter_sidebar.dart';

class VCartFilterPage extends StatefulWidget {
  final String? sectionId;
  final String? brandId;

  const VCartFilterPage({super.key, this.sectionId, this.brandId});

  @override
  State<VCartFilterPage> createState() => _VCartFilterPageState();
}

class _VCartFilterPageState extends State<VCartFilterPage> {
  late VCartFilterPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VCartFilterPageController>();
    controller.getFilterData(
      sectionId: widget.sectionId,
      brandId: widget.brandId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VCartColors.background,
      appBar: _buildAppBar(),
      body: GetBuilder<VCartFilterPageController>(
        init: controller,
        builder: (controller) {
          return Obx(() {
            if (controller.hasError) {
              return VCartErrorWidget(
                message: controller.errorMessage,
                onRetry: () => controller.refreshData(
                  sectionId: widget.sectionId,
                  brandId: widget.brandId,
                ),
              );
            }

            return Skeletonizer(
              enabled: controller.isLoading,
              child: Row(
                children: [
                  FilterSidebar(controller: controller),
                  Expanded(child: FilterContent(controller: controller)),
                ],
              ),
            );
          });
        },
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VCartColors.background,
      automaticallyImplyLeading: false,
      title: const Text(
        "Filter",
        style: TextStyle(color: VCartColors.textPrimary, fontSize: 18),
      ),
      centerTitle: false,
      actions: [
        TextButton(
          onPressed: () {
            controller.clearAllFilters();
          },
          child: const Text(
            "Clear Filter",
            style: TextStyle(fontSize: 14, color: VCartColors.error),
          ),
        ),
        IconButton(
          onPressed: () => VCartRouterClassG.backInVCart(),
          icon: const Icon(Icons.close, color: VCartColors.error),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: VCartColors.border.withOpacity(.3),
          height: 1.0,
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 80,
      padding: context.horizontalPadding.add(
        const EdgeInsets.symmetric(vertical: 12),
      ),
      decoration: BoxDecoration(
        color: VCartColors.background,
        boxShadow: [
          BoxShadow(
            color: VCartColors.surfaceOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: context.screenWidth * 0.04),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                  "${controller.filterState.hasActiveFilters ? 'Filtered' : 'All'} Products",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: VCartColors.textPrimary,
                  ),
                ),
              ),
              const Text(
                "Products Found",
                style: TextStyle(
                  fontSize: 12,
                  color: VCartColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => controller.applyFilters(context),
            child: Container(
              width: context.screenWidth * 0.35,
              height: 48,
              decoration: BoxDecoration(
                color: VCartColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Apply",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: VCartColors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
