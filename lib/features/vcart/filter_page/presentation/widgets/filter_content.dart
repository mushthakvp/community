import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/vcart_extensions.dart';
import '../controllers/filter_page_controller.dart';
import 'brand_filter_widget.dart';
import 'color_filter_widget.dart';
import 'offer_filter_widget.dart';
import 'price_filter_widget.dart';
import 'size_filter_widget.dart';

class FilterContent extends StatelessWidget {
  final VCartFilterPageController controller;

  const FilterContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.horizontalPadding,
      child: Obx(() {
        switch (controller.selectedFilterIndex) {
          case 0:
            return PriceFilterWidget(controller: controller);
          case 1:
            return BrandFilterWidget(controller: controller);
          case 2:
            return SizeFilterWidget(controller: controller);
          case 3:
            return ColorFilterWidget(controller: controller);
          case 4:
            return OfferFilterWidget(controller: controller);
          default:
            return PriceFilterWidget(controller: controller);
        }
      }),
    );
  }
}
