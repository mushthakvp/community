import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/spacer_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/place_add_provider.dart';
import '../widgets/category_grid_widget.dart';

class SelectCategoryPage extends StatefulWidget {
  const SelectCategoryPage({super.key});

  @override
  State<SelectCategoryPage> createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PlaceAddProvider>();
      provider.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(
        title: 'Select Category',
        showBackButton: true,
      ),
      body: Consumer<PlaceAddProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading categories...'),
            );
          }
          final result = provider.categoriesResult;
          if (result == null) {
            return _buildEmptyState(provider);
          }
          if (result.isError) {
            return _buildErrorState(provider, result.errorMessage);
          }
          final categories = provider.categories!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildHeader(provider),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryGridWidget(
                        categories: categories,
                        onCategorySelected: (category) {
                          provider.selectCategory(category);
                          context.push(RouteConstants.selectSubCategory);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(PlaceAddProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'What are you listing?',
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        AppSpacing.verticalSM,
        CommonTextWidget(
          text: 'Choose the right category for your item',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
        ),
        if (provider.selectedCity != null) ...[
          AppSpacing.verticalMD,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppConstants.appPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppConstants.appPrimaryColor,
                ),
                const SizedBox(width: 4),
                CommonTextWidget(
                  text: provider.selectedCity!,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.appPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState(PlaceAddProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category,
            size: 80,
            color: AppConstants.white.withOpacity(0.3),
          ),
          AppSpacing.verticalMD,
          const CommonTextWidget(
            text: 'No categories available',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          AppSpacing.verticalSM,
          CommonTextWidget(
            text: 'Please try again later',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.6),
          ),
          AppSpacing.verticalXL,
          ElevatedButton(
            onPressed: () => provider.loadCategories(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              foregroundColor: AppConstants.black,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(PlaceAddProvider provider, String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppConstants.error, size: 80),
          AppSpacing.verticalMD,
          const CommonTextWidget(
            text: 'Failed to load categories',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          AppSpacing.verticalSM,
          CommonTextWidget(
            text: errorMessage ?? 'Something went wrong',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.6),
            align: TextAlign.center,
          ),
          AppSpacing.verticalXL,
          ElevatedButton(
            onPressed: () => provider.loadCategories(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              foregroundColor: AppConstants.black,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
