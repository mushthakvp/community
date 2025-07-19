import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/product_overview_controller.dart';
import 'specification_tab.dart';

class ProductTabsSection extends StatelessWidget {
  final VCartProductOverviewController controller;

  const ProductTabsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Specifications",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: VCartColors.primary,
          ),
        ),
        SizedBox(height: context.screenHeight * 0.02),
        SpecificationTab(controller: controller),
      ],
    );
  }
}
