import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/categories_controller.dart';

class SectionsPanel extends StatelessWidget {
  final VCartCategoriesController controller;

  const SectionsPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * 0.35,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [VCartColors.surface, Color(0xFF242323)],
          stops: [0, 0.5],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Obx(() {
        if (controller.sections.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: controller.sections.length,
          separatorBuilder: (context, index) => _buildDivider(context, index),
          itemBuilder: (context, index) => _buildSectionItem(context, index),
        );
      }),
    );
  }

  Widget _buildDivider(BuildContext context, int index) {
    return Divider(
      height: 0,
      thickness: 0.5,
      indent: controller.selectedSectionIndex == index ? 0 : 20,
      endIndent: controller.selectedSectionIndex == index ? 0 : 20,
      color: VCartColors.textPrimary.withOpacity(0.1),
    );
  }

  Widget _buildSectionItem(BuildContext context, int index) {
    final section = controller.sections[index];
    final isSelected = controller.selectedSectionIndex == index;

    return InkWell(
      onTap: () => controller.onSectionTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: VCartConstants.defaultPadding,
          horizontal: VCartConstants.smallPadding,
        ),
        color: isSelected
            ? VCartColors.primaryOpacity(0.2)
            : Colors.transparent,
        child: Column(
          children: [
            _buildSectionImage(section.imageUrl),
            const SizedBox(height: 5),
            Text(
              section.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? VCartColors.primary
                    : VCartColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionImage(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: VCartColors.border),
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: VCartColors.borderLight),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl.orPlaceholder,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: VCartColors.surface,
              child: const Icon(
                Icons.category_outlined,
                color: VCartColors.textSecondary,
                size: 20,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: VCartColors.surface,
              child: const Icon(
                Icons.broken_image_outlined,
                color: VCartColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
