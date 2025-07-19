import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/widgets/vcart_text_field.dart';
import '../controllers/filter_page_controller.dart';

class BrandFilterWidget extends StatelessWidget {
  final VCartFilterPageController controller;

  const BrandFilterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.screenHeight * 0.02),
        VCartTextField(
          controller: controller.brandSearchController,
          hintText: "Search Brand",
          prefixIcon: const Icon(
            Icons.search,
            color: VCartColors.textSecondary,
          ),
        ),
        SizedBox(height: context.screenHeight * 0.01),
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: EdgeInsets.only(
                top: context.screenHeight * 0.02,
                bottom: context.screenHeight * 0.15,
              ),
              itemCount: controller.brands.length,
              itemBuilder: (context, index) {
                final brand = controller.brands[index];
                final isSelected = controller.filterState.selectedBrands
                    .contains(brand.id);

                return CheckboxListTile(
                  side: BorderSide(color: VCartColors.border),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: isSelected,
                  onChanged: (value) => controller.toggleBrand(brand.id),
                  title: Text(
                    brand.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: VCartColors.textPrimary.withOpacity(.8),
                    ),
                  ),
                  checkColor: VCartColors.onPrimary,
                  activeColor: VCartColors.primary.withOpacity(.8),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
