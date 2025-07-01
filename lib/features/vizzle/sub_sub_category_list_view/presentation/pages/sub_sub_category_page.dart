import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';
import '../providers/sub_sub_category_provider.dart';
import '../widgets/sub_sub_category_list.dart';

class SubSubCategoryPage extends StatefulWidget {
  final String categoryName;
  final String subCategoryName;
  final String subCategoryId;
  final String categoryId;
  final String isFromListAd;

  const SubSubCategoryPage({
    super.key,
    required this.categoryName,
    required this.subCategoryName,
    required this.subCategoryId,
    required this.categoryId,
    required this.isFromListAd,
  });

  @override
  State<SubSubCategoryPage> createState() => _SubSubCategoryPageState();
}

class _SubSubCategoryPageState extends State<SubSubCategoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubSubCategoryProvider>().loadSubSubCategories(
        subCategoryId: widget.subCategoryId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(title: widget.subCategoryName, showBackButton: true),
      body: Consumer<SubSubCategoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasData) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError && !provider.hasData) {
            return _buildErrorWidget(provider);
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshData(widget.subCategoryId),
            child: SubSubCategoryList(
              subSubCategories: provider.subSubCategories,
              onSubSubCategoryTap: (subSubCategory) =>
                  _handleSubSubCategoryTap(subSubCategory),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(SubSubCategoryProvider provider) {
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
            onPressed: () => provider.refreshData(widget.subCategoryId),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _handleSubSubCategoryTap(SubSubCategoryEntity subSubCategory) {
    if (subSubCategory.subItems.isEmpty) {
      if (widget.isFromListAd == 'true') {
        context.push(
          RouteConstants.vizzleAdsListing,
          extra: {
            'subCategoryName': subSubCategory.name,
            'subCategoryId': widget.subCategoryId,
            'categoryName': widget.categoryName,
            'categoryId': widget.categoryId,
            'subSubCategoryId': subSubCategory.id,
            'subItemsId': '',
          },
        );
      } else {
        _navigateBasedOnCategory(subSubCategory);
      }
    } else {
      context.push(
        '${RouteConstants.vizzleSubItems}/${subSubCategory.id}',
        extra: {
          'subSubCategoryName': subSubCategory.name,
          'categoryName': widget.categoryName,
          'categoryId': widget.categoryId,
          'subCategoryName': widget.subCategoryName,
          'subCategoryId': widget.subCategoryId,
          'isFromListAd': widget.isFromListAd == 'true',
        },
      );
    }
  }

  void _navigateBasedOnCategory(SubSubCategoryEntity subSubCategory) {
    // switch (widget.categoryName) {
    //   case "Classifieds":
    //     context.push(
    //       RouteConstants.vizzleCreateClassifiedAd,
    //       extra: {
    //         'category': widget.subCategoryName,
    //         'subSubCategoryId': subSubCategory.id,
    //         'subItemsId': '',
    //       },
    //     );
    //     break;
    //   case "Furniture & Garden":
    //     context.push(
    //       RouteConstants.vizzleCreateFurnitureAd,
    //       extra: {
    //         'category': widget.subCategoryName,
    //         'subSubCategoryId': subSubCategory.id,
    //         'subItemsId': '',
    //       },
    //     );
    //     break;
    //   case "Motors":
    //     context.push(
    //       RouteConstants.vizzleCreateMotorAd,
    //       extra: {
    //         'category': widget.subCategoryName,
    //         'subSubCategoryId': subSubCategory.id,
    //         'subItemsId': '',
    //       },
    //     );
    //     break;
    //   case "Property For Sale":
    //     context.push(
    //       RouteConstants.vizzlePropertySubLand,
    //       extra: {
    //         'category': widget.subCategoryName,
    //         'subSubCategoryId': subSubCategory.id,
    //       },
    //     );
    //     break;
    //   case 'Community':
    //     context.push(
    //       RouteConstants.vizzleAddCommunity,
    //       extra: {
    //         'category': widget.subCategoryName,
    //         'subSubCategoryId': subSubCategory.id,
    //       },
    //     );
    //     break;
    //   case 'Property For Rent':
    //     context.push(
    //       RouteConstants.vizzleSelectAgentOrLandlord,
    //       extra: {
    //         'category': widget.subCategoryName,
    //         'subSubCategoryId': subSubCategory.id,
    //       },
    //     );
    //     break;
    //   default:
    //     // Handle default case or show error
    //     break;
    // }
  }
}
