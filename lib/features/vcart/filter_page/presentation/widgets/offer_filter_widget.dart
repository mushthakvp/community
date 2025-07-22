import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/filter_page_controller.dart';

class OfferFilterWidget extends StatelessWidget {
  final VCartFilterPageController controller;

  const OfferFilterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: context.screenHeight * 0.02,
        bottom: context.screenHeight * 0.15,
      ),
      itemCount: controller.availableOffers.length,
      itemBuilder: (context, index) {
        final offer = controller.availableOffers[index];

        return Obx(() {
          final isSelected = controller.filterState.selectedOffers.contains(
            offer,
          );

          return CheckboxListTile(
            side: BorderSide(color: VCartColors.border),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              "$offer% off",
              style: const TextStyle(
                fontSize: 14,
                color: VCartColors.textPrimary,
              ),
            ),
            value: isSelected,
            onChanged: (value) => controller.toggleOffer(offer),
            checkColor: VCartColors.onPrimary,
            activeColor: VCartColors.primary.withOpacity(.8),
          );
        });
      },
    );
  }
}
