import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/coupon_provider.dart';
import '../widgets/app_filter_list.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/coupon_error_widget.dart';
import '../widgets/coupon_list.dart';
import '../widgets/coupon_search_bar.dart';

class CouponHomePage extends StatefulWidget {
  const CouponHomePage({super.key});

  @override
  State<CouponHomePage> createState() => _CouponHomePageState();
}

class _CouponHomePageState extends State<CouponHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CouponProvider>().loadCoupons();
      context.read<CouponProvider>().loadCategories();
      context.read<CouponProvider>().loadApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Coupons', showBackButton: true),
      body: Consumer<CouponProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.coupons.isEmpty) {
            return const Center(child: LoadingWidget());
          }

          if (provider.hasError && provider.coupons.isEmpty) {
            return CouponErrorWidget(
              message: provider.errorMessage ?? 'Something went wrong',
              onRetry: () => provider.loadCoupons(forceRefresh: true),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadCoupons(forceRefresh: true),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const CouponSearchBar(),
                      const SizedBox(height: 16),
                      const CategoryFilterChips(),
                      const SizedBox(height: 16),
                      const AppFilterList(),
                      const SizedBox(height: 16),
                    ]),
                  ),
                ),
                const CouponList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
