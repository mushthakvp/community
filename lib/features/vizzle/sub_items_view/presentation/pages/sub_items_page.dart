import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../../domain/entities/vizzle_entities.dart';
import '../providers/sub_items_provider.dart';
import '../widgets/sub_items_list.dart';

class SubItemsPage extends StatefulWidget {
  final String subSubCategoryId;
  final String subSubCategoryName;
  final String categoryName;
  final String subCategoryName;
  final String categoryId;
  final String subCategoryId;
  final bool isFromListAd;

  const SubItemsPage({
    super.key,
    required this.subSubCategoryId,
    required this.subSubCategoryName,
    required this.categoryName,
    required this.subCategoryName,
    required this.categoryId,
    required this.subCategoryId,
    required this.isFromListAd,
  });

  @override
  State<SubItemsPage> createState() => _SubItemsPageState();
}

class _SubItemsPageState extends State<SubItemsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubItemsProvider>().loadSubItems(
        subSubCategoryId: widget.subSubCategoryId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: widget.subSubCategoryName,
        showBackButton: true,
      ),
      body: Consumer<SubItemsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasData) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError && !provider.hasData) {
            return _buildErrorWidget(provider);
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshData(widget.subSubCategoryId),
            child: SubItemsList(
              subItems: provider.subItems,
              onSubItemTap: (subItem) => _handleSubItemTap(subItem),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(SubItemsProvider provider) {
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
            onPressed: () => provider.refreshData(widget.subSubCategoryId),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _handleSubItemTap(SubItemEntity subItem) {
    context.push(
      RouteConstants.vizzleAdsListing,
      extra: {
        'categoryId': widget.categoryId,
        'subCategoryId': widget.subCategoryId,
        'subSubCategoryId': widget.subSubCategoryId,
        'subItemId': subItem.id,
        'categoryName': widget.categoryName,
        'subCategoryName': widget.subCategoryName,
        'subSubCategoryName': widget.subSubCategoryName,
        'subItemName': subItem.name,
      },
    );
  }
}
