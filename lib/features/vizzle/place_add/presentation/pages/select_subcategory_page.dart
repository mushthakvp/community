import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../domain/entities/category.dart';
import '../providers/place_add_provider.dart';

class SelectSubCategoryPage extends StatelessWidget {
  const SelectSubCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(
        title: 'Select Subcategory',
        showBackButton: true,
      ),
      body: Consumer<PlaceAddProvider>(
        builder: (context, provider, child) {
          final selectedCategory = provider.selectedCategory;

          if (selectedCategory == null) {
            return const Center(
              child: CommonTextWidget(
                text: 'No category selected',
                fontSize: 16,
              ),
            );
          }

          if (selectedCategory.subcategories.isEmpty) {
            // If no subcategories, go directly to create ad
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setUpCategoryData(provider, selectedCategory, null);
              context.push(RouteConstants.createAd);
            });
            return const Center(child: LoadingWidget());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: 'Select a subcategory for ${selectedCategory.name}',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),
                CommonTextWidget(
                  text: 'Choose the most relevant subcategory',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppConstants.white.withOpacity(0.7),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: selectedCategory.subcategories.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppConstants.white.withOpacity(0.1),
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      final subCategory = selectedCategory.subcategories[index];
                      return _SubCategoryTile(
                        subCategory: subCategory,
                        onTap: () {
                          provider.selectSubCategory(subCategory);
                          _setUpCategoryData(
                            provider,
                            selectedCategory,
                            subCategory,
                          );
                          context.push(RouteConstants.createAd);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _setUpCategoryData(
    PlaceAddProvider provider,
    Category category,
    SubCategory? subCategory,
  ) {
    // Set the category IDs for API
    provider.sectionIdStoreController.text = category.id;
    provider.selectedCategoryIdController.text = subCategory?.id ?? '';

    // Store category name for reference
    provider.categoryController.text = category.name;
  }
}

class _SubCategoryTile extends StatelessWidget {
  final SubCategory subCategory;
  final VoidCallback onTap;

  const _SubCategoryTile({required this.subCategory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppConstants.appPrimaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  _getSubCategoryIcon(subCategory.name),
                  color: AppConstants.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CommonTextWidget(
                  text: subCategory.name,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppConstants.appPrimaryColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSubCategoryIcon(String subCategoryName) {
    final name = subCategoryName.toLowerCase();

    // Motor subcategories
    if (name.contains('car')) return Icons.directions_car;
    if (name.contains('motorcycle') || name.contains('bike')) {
      return Icons.motorcycle;
    }
    if (name.contains('truck')) return Icons.local_shipping;
    if (name.contains('boat')) return Icons.directions_boat;
    if (name.contains('part') || name.contains('accessory')) return Icons.build;

    // Electronics subcategories
    if (name.contains('mobile') || name.contains('phone')) {
      return Icons.smartphone;
    }
    if (name.contains('computer') || name.contains('laptop')) {
      return Icons.computer;
    }
    if (name.contains('tablet')) return Icons.tablet;
    if (name.contains('camera')) return Icons.camera_alt;
    if (name.contains('tv') || name.contains('television')) return Icons.tv;
    if (name.contains('audio') || name.contains('speaker')) {
      return Icons.speaker;
    }

    // Property subcategories
    if (name.contains('apartment') || name.contains('flat')) {
      return Icons.apartment;
    }
    if (name.contains('house') || name.contains('villa')) return Icons.house;
    if (name.contains('land') || name.contains('plot')) return Icons.landscape;
    if (name.contains('commercial')) return Icons.business;
    if (name.contains('office')) return Icons.local_post_office_sharp;

    // Furniture subcategories
    if (name.contains('chair') || name.contains('seat')) return Icons.chair;
    if (name.contains('table')) return Icons.table_restaurant;
    if (name.contains('bed')) return Icons.bed;
    if (name.contains('sofa')) return Icons.weekend;
    if (name.contains('kitchen')) return Icons.kitchen;
    if (name.contains('garden')) return Icons.grass;

    // Default icon
    return Icons.category;
  }
}
