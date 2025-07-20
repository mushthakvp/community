import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livera/features/vcart/core/router/v_cart_router_g.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/section_category_controller.dart';
import '../widgets/section_category_grid.dart';

class VCartSectionCategoryPage extends StatefulWidget {
  final String title;
  final String sectionId;

  const VCartSectionCategoryPage({
    super.key,
    required this.title,
    required this.sectionId,
  });

  @override
  State<VCartSectionCategoryPage> createState() =>
      _VCartSectionCategoryPageState();
}

class _VCartSectionCategoryPageState extends State<VCartSectionCategoryPage> {
  late VCartSectionCategoryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VCartSectionCategoryController>();
    controller.getCategoriesBySection(
      sectionId: widget.sectionId,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VCartColors.background,
      appBar: _buildAppBar(),
      body: GetBuilder<VCartSectionCategoryController>(
        init: controller,
        builder: (controller) {
          return Obx(() {
            if (controller.hasError) {
              return VCartErrorWidget(
                message: controller.errorMessage,
                onRetry: () =>
                    controller.refreshData(widget.sectionId, context),
              );
            }

            if (controller.isEmpty) {
              return VCartMaintenanceWidget(
                title: '${widget.title} Categories are Empty!',
                subtitle: 'Check back later for new categories.',
              );
            }

            return Skeletonizer(
              enabled: controller.isLoading,
              child: SingleChildScrollView(
                padding: context.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.title} Essentials by Category',
                      style: TextStyle(
                        fontSize: context.screenWidth * 0.045,
                        color: VCartColors.textPrimary.withOpacity(.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SectionCategoryGrid(
                      categories: controller.categories,
                      sectionId: widget.sectionId,
                      onCategoryTap: (category) =>
                          _navigateToProducts(category.id),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      backgroundColor: VCartColors.background,
      leading: IconButton(
        onPressed: () => VCartRouterClassG.backInVCart(),
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
      title: Text(
        widget.title,
        style: const TextStyle(color: VCartColors.textPrimary, fontSize: 18),
      ),
    );
  }

  void _navigateToProducts(String categoryId) {
    // Navigate to product listing with section and category filters
    Get.toNamed(
      '/products',
      parameters: {
        'sectionId': widget.sectionId,
        'categoryId': categoryId,
        'title': widget.title,
      },
    );
  }
}
