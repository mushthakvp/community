import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/vizzle_home_provider.dart';

class VizzleCategoryGrid extends StatelessWidget {
  const VizzleCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VizzleHomeProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: provider.categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = provider.categories[index];
              return _CategoryCard(
                title: category['title'],
                icon: category['icon'],
                onTap: () {
                  context.push(
                    '${RouteConstants.vizzleCategory}/${category['categoryName']}',
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: AppConstants.white.withOpacity(0.1),
                border: Border.all(
                  color: AppConstants.appPrimaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppConstants.appPrimaryColor, size: 28),
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: title,
              color: AppConstants.appPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              maxLines: 2,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
