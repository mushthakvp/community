import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/card_widget.dart';
import '../../../../../core/widgets/common/inkwell_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/add_edit_provider.dart';

class CategorySelectionWidget extends StatelessWidget {
  const CategorySelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddEditProvider>(
      builder: (context, provider, child) {
        if (provider.citiesResponse?.categories == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: "Category",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3,
              ),
              itemCount: provider.citiesResponse!.categories!.length,
              itemBuilder: (context, index) {
                final category = provider.citiesResponse!.categories![index];
                final isSelected = provider.selectedCategoryId == category.id;

                return CommonInkWell(
                  onTap: () => provider.selectCategory(category),
                  child: CommonCard(
                    backgroundColor: isSelected
                        ? AppConstants.appPrimaryColor.withOpacity(0.2)
                        : AppConstants.surfaceVariant,
                    borderColor: isSelected
                        ? AppConstants.appPrimaryColor
                        : AppConstants.white.withOpacity(0.1),
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(category.name ?? ''),
                          size: 24,
                          color: isSelected
                              ? AppConstants.appPrimaryColor
                              : AppConstants.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CommonTextWidget(
                            text: category.name ?? '',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppConstants.appPrimaryColor
                                : AppConstants.white,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'motors':
        return Icons.directions_car;
      case 'classifieds':
        return Icons.category;
      case 'furniture & garden':
        return Icons.chair;
      case 'freshly grown':
        return Icons.eco;
      case 'property for sale':
        return Icons.home;
      case 'electronics':
        return Icons.devices;
      case 'mobile phones & tablets':
        return Icons.smartphone;
      case 'computers & networking':
        return Icons.computer;
      default:
        return Icons.category;
    }
  }
}
