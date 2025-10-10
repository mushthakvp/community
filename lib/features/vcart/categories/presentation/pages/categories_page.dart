import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../shared/presentation/widgets/error_widget.dart';
import '../../../shared/presentation/widgets/maintenance_widget.dart';
import '../controllers/categories_controller.dart';
import '../widgets/categories_content.dart';
import '../widgets/sections_panel.dart';

class VCartCategoriesPage extends StatelessWidget {
  const VCartCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VCartCategoriesController>(
      init: Get.find<VCartCategoriesController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: VCartColors.background,
          appBar: _buildAppBar(),
          body: Obx(() {
            if (controller.hasError) {
              return VCartErrorWidget(
                message: controller.errorMessage,
                onRetry: () => controller.refreshData(),
              );
            }
            if (controller.sections.isEmpty && !controller.isLoading) {
              return const VCartMaintenanceWidget(
                title: 'Oops!',
                subtitle:
                    'We are not able to fetch categories at the moment. Please try again later.',
              );
            }
            return Skeletonizer(
              enabled: controller.isLoading,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionsPanel(controller: controller),
                  CategoriesContent(controller: controller),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: VCartColors.background,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text(
        "All Categories",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: VCartColors.textPrimary,
        ),
      ),
      elevation: 0,
    );
  }
}
