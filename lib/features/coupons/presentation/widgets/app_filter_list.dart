import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/coupon_provider.dart';

class AppFilterList extends StatelessWidget {
  const AppFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponProvider>(
      builder: (context, provider, child) {
        if (provider.apps.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Filter by App',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: provider.apps.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final app = provider.apps[index];
                  final isSelected = app.id == provider.selectedAppId;

                  return GestureDetector(
                    onTap: () => provider.selectApp(isSelected ? '' : app.id),
                    child: AnimatedContainer(
                      duration: AppConstants.defaultAnimationDuration,
                      width: 70,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppConstants.appPrimaryColor
                              : AppConstants.white.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppConstants.appPrimaryColor
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: app.logo,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: const Color(0xFF2A2A2A),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: AppConstants.appPrimaryColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: const Color(0xFF2A2A2A),
                                  child: const Icon(
                                    Icons.image,
                                    color: AppConstants.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          CommonTextWidget(
                            text: app.name,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppConstants.appPrimaryColor
                                : AppConstants.white.withOpacity(0.8),
                            maxLines: 1,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
