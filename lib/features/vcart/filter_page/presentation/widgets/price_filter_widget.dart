import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_text_field.dart';
import '../controllers/filter_page_controller.dart';

class PriceFilterWidget extends StatelessWidget {
  final VCartFilterPageController controller;

  const PriceFilterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.screenHeight * 0.02),
        VCartTextField(
          controller: controller.minPriceController,
          hintText: "Min Price",
          keyboardType: TextInputType.number,
          suffixIcon: const Text("RS"),
        ),
        SizedBox(height: context.screenHeight * 0.02),
        VCartTextField(
          controller: controller.maxPriceController,
          hintText: "Max Price",
          keyboardType: TextInputType.number,
          suffixIcon: const Text("RS"),
        ),
        SizedBox(height: context.screenHeight * 0.02),
        Obx(
          () => RangeSlider(
            min: 0,
            max: 500000,
            values: controller.priceRange,
            onChanged: (RangeValues newValues) {
              controller.updatePriceRange(newValues);
            },
            activeColor: VCartColors.primary,
            inactiveColor: VCartColors.border,
          ),
        ),
      ],
    );
  }
}
