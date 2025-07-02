import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
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
      context.read<PlaceAddProvider>().loadCategories();
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
            return const Center(
              child: CommonTextWidget(text: 'No data available', fontSize: 16),
            );
          }

          if (result.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppConstants.error,
                    size: 64,
                  ),
                  AppSpacing.verticalMD,
                  CommonTextWidget(
                    text: result.errorMessage ?? 'Something went wrong',
                    fontSize: 16,
                    align: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final categories = provider.categories!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonTextWidget(
                  text: 'What are you listing?',
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  align: TextAlign.center,
                ),
                AppSpacing.verticalSM,
                const CommonTextWidget(
                  text: 'Choose the right category',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  align: TextAlign.center,
                ),
                AppSpacing.verticalXL,
                Expanded(
                  child: CategoryGridWidget(
                    categories: categories,
                    onCategorySelected: (category) {
                      provider.selectCategory(category);
                      Navigator.pushNamed(context, '/select-subcategory');
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
}
