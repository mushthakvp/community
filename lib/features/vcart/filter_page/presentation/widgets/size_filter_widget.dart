import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/filter_page_controller.dart';

class SizeFilterWidget extends StatelessWidget {
  final VCartFilterPageController controller;

  const SizeFilterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.only(
          top: context.screenHeight * 0.02,
          bottom: context.screenHeight * 0.15,
        ),
        itemCount: controller.sizes.length,
        itemBuilder: (context, index) {
          final size = controller.sizes[index];
          final isSelected = controller.filterState.selectedSizes.contains(
            size,
          );

          return CheckboxListTile(
            side: BorderSide(color: VCartColors.border),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              size.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                color: VCartColors.textPrimary,
              ),
            ),
            value: isSelected,
            onChanged: (value) => controller.toggleSize(size),
            checkColor: VCartColors.onPrimary,
            activeColor: VCartColors.primary.withOpacity(.8),
          );
        },
      ),
    );
  }
}
