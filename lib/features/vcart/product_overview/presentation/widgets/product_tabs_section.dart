import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/product_overview_controller.dart';
import 'return_policy_tab.dart';
import 'specification_tab.dart';

class ProductTabsSection extends StatelessWidget {
  final VCartProductOverviewController controller;

  const ProductTabsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            indicatorColor: VCartColors.primary,
            labelColor: VCartColors.primary,
            unselectedLabelColor: VCartColors.textPrimary,
            dividerColor: VCartColors.textPrimary.withOpacity(0.1),
            indicatorWeight: 5,
            onTap: controller.changeTabIndex,
            tabs: const [
              Tab(text: "Specification"),
              Tab(text: "Return Policy"),
            ],
          ),
          SizedBox(height: context.screenHeight * 0.02),
          Obx(() {
            switch (controller.tabIndex) {
              case 0:
                return SpecificationTab(controller: controller);
              default:
                return ReturnPolicyTab(
                  policy: controller.productDetail?.returnPolicy ?? '',
                );
            }
          }),
        ],
      ),
    );
  }
}
