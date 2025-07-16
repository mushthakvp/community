// lib/features/coupons/presentation/widgets/coupon_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/coupon_provider.dart';
import 'coupon_card_optimized.dart';
import 'empty_coupons_widget.dart';

class CouponList extends StatelessWidget {
  const CouponList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponProvider>(
      builder: (context, provider, child) {
        if (provider.coupons.isEmpty) {
          return SliverToBoxAdapter(
            child: EmptyCouponsWidget(
              message: provider.searchQuery.isNotEmpty
                  ? 'No coupons found for "${provider.searchQuery}"'
                  : 'No coupons available at the moment',
              onRefresh: () => provider.loadCoupons(forceRefresh: true),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final coupon = provider.coupons[index];

              return CouponCardOptimized(
                coupon: coupon,
                onLike: () => provider.likeCoupon(coupon.id),
                onDislike: (reason) =>
                    provider.dislikeCoupon(coupon.id, reason),
                onUse: () => provider.useCoupon(coupon.id),
                formatTime: provider.formatLastUsedTime,
              );
            }, childCount: provider.coupons.length),
          ),
        );
      },
    );
  }
}
