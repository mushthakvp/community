import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/ad_entity.dart';
import 'ad_card.dart';

class AdsGridView extends StatelessWidget {
  final List<AdEntity> ads;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final Function(String) onAdTap;
  final Function(String) onFavoriteTap;

  const AdsGridView({
    super.key,
    required this.ads,
    required this.scrollController,
    required this.isLoadingMore,
    required this.onAdTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final ad = ads[index];
              return AdCard(
                ad: ad,
                onTap: () => onAdTap(ad.id),
                onFavoriteTap: () => onFavoriteTap(ad.id),
                cardType: AdCardType.grid,
              );
            }, childCount: ads.length),
          ),
        ),

        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppConstants.appPrimaryColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
