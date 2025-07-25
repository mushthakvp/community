import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/preview_controller.dart';

class RecipeTabsSection extends StatelessWidget {
  final PreviewController controller;

  const RecipeTabsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff1E1E1E),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
        child: Row(
          children: [
            _buildTabButton(
              index: 0,
              title: 'Ingredients',
              isSelected: controller.selectedTabIndex == 0,
            ),
            _buildTabButton(
              index: 1,
              title: 'Steps',
              isSelected: controller.selectedTabIndex == 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String title,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Colors.amber : const Color(0xff1E1E1E),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.black
                    : Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
