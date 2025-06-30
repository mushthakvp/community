import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/inkwell_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/add_edit_provider.dart';

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(
        title: "Select Category",
        showBackButton: true,
      ),
      body: Consumer<AddEditProvider>(
        builder: (context, provider, child) {
          final categories = provider.citiesResponse?.categories ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    CommonTextWidget(
                      text: provider.selectedCategory?.name ?? "Categories",
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      align: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const CommonTextWidget(
                      text: "Choose the right category for better reach",
                      fontSize: 14,
                      color: AppConstants.onSurfaceSecondary,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                  ),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppConstants.white.withOpacity(0.1),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return CommonInkWell(
                      onTap: () {
                        provider.selectCategory(category);
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIcon(category.name ?? ''),
                              color: AppConstants.appPrimaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CommonTextWidget(
                                text: category.name ?? '',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppConstants.white.withOpacity(0.4),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
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
