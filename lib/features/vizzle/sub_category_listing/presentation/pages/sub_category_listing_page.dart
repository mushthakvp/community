import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/sub_category_listing_provider.dart';
import '../widgets/sub_category_list.dart';

class SubCategoryListingPage extends StatefulWidget {
  final String categoryName;

  const SubCategoryListingPage({super.key, required this.categoryName});

  @override
  State<SubCategoryListingPage> createState() => _SubCategoryListingPageState();
}

class _SubCategoryListingPageState extends State<SubCategoryListingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubCategoryListingProvider>().loadSubCategories(
        categoryName: widget.categoryName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(title: widget.categoryName, showBackButton: true),
      body: Consumer<SubCategoryListingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasData) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError && !provider.hasData) {
            return _buildErrorWidget(provider);
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshData(widget.categoryName),
            child: SubCategoryList(
              categoryName: widget.categoryName,
              categoryId: provider.categoryId,
              subCategories: provider.subCategories,
              onSubCategoryTap: (subCategory) =>
                  _handleSubCategoryTap(subCategory),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(SubCategoryListingProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            provider.errorMessage ?? 'Something went wrong',
            style: const TextStyle(color: AppConstants.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => provider.refreshData(widget.categoryName),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _handleSubCategoryTap(dynamic subCategory) {
    final subCategoryName = subCategory.name ?? '';
    final subCategoryId = subCategory.id ?? '';
    final categoryId = context.read<SubCategoryListingProvider>().categoryId;
    if (widget.categoryName == 'Freshly Grown') {
      context.push(
        RouteConstants.vizzleAdsListing,
        extra: {
          'subCategoryName': subCategoryName,
          'subCategoryId': subCategoryId,
          'categoryName': widget.categoryName,
          'categoryId': categoryId,
        },
      );
    } else if (widget.categoryName == 'Property For Sale') {
      if (subCategoryName == "Land" || subCategoryName == "Multiple Units") {
        context.push(
          RouteConstants.vizzleAdsListing,
          extra: {
            'subCategoryName': subCategoryName,
            'subCategoryId': subCategoryId,
            'categoryName': widget.categoryName,
            'categoryId': categoryId,
          },
        );
      } else {
        context.push(
          '${RouteConstants.vizzleSubCategory}/${widget.categoryName}/$subCategoryId',
          extra: {
            'subCategoryName': subCategoryName,
            'categoryId': categoryId,
            'isFromListAd': 'true',
          },
        );
      }
    } else {
      context.push(
        '${RouteConstants.vizzleSubCategory}/${widget.categoryName}/$subCategoryId',
        extra: {
          'subCategoryName': subCategoryName,
          'categoryId': categoryId,
          'isFromListAd': 'true',
        },
      );
    }
  }
}
