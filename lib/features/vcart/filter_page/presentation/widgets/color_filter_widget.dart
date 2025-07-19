import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/filter_page_controller.dart';

class ColorFilterWidget extends StatelessWidget {
  final VCartFilterPageController controller;

  const ColorFilterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.only(
          top: context.screenHeight * 0.02,
          bottom: context.screenHeight * 0.15,
        ),
        itemCount: controller.colors.length,
        itemBuilder: (context, index) {
          final color = controller.colors[index];
          final isSelected = controller.filterState.selectedColors.contains(
            color.color,
          );

          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            side: BorderSide(color: VCartColors.border),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: VCartColors.border,
                  child: CircleAvatar(
                    radius: 9.8,
                    backgroundColor: controller.hexToColor(color.colorCode),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  color.color.capitalizeFirst ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: VCartColors.textPrimary,
                  ),
                ),
              ],
            ),
            value: isSelected,
            onChanged: (value) => controller.toggleColor(color.color),
            checkColor: VCartColors.onPrimary,
            activeColor: VCartColors.primary.withOpacity(.8),
          );
        },
      ),
    );
  }
}
