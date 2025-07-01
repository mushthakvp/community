import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/ad_entity.dart';
import 'ad_card.dart';

class AdsListView extends StatelessWidget {
  final List<AdEntity> ads;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final Function(String) onAdTap;
  final Function(String) onFavoriteTap;

  const AdsListView({
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
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final ad = ads[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AdCard(
                  ad: ad,
                  onTap: () => onAdTap(ad.id),
                  onFavoriteTap: () => onFavoriteTap(ad.id),
                  cardType: AdCardType.list,
                ),
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
