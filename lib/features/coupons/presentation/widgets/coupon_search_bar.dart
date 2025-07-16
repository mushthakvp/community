// lib/features/coupons/presentation/widgets/coupon_search_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../providers/coupon_provider.dart';

class CouponSearchBar extends StatelessWidget {
  const CouponSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponProvider>(
      builder: (context, provider, child) {
        return CommonTextField(
          controller: provider.searchController,
          hintText: 'Search coupons...',
          prefixIcon: const Icon(Icons.search, color: AppConstants.white),
          suffixIcon: provider.searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    provider.searchController.clear();
                    provider.onSearchChanged('');
                  },
                  icon: const Icon(Icons.clear, color: AppConstants.white),
                )
              : null,
          onChanged: provider.onSearchChanged,
        );
      },
    );
  }
}
