import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class VizzleMarketplaceCategories extends StatelessWidget {
  const VizzleMarketplaceCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = _getMarketplaceCategories();

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final category = categories[index];
        return _CategoryCard(
          title: category['title'],
          icon: category['icon'],
          color: category['color'],
          onTap: () {
            context.push(
              '${RouteConstants.vizzleCategory}/${category['categoryName']}',
            );
          },
        );
      }, childCount: categories.length),
    );
  }

  List<Map<String, dynamic>> _getMarketplaceCategories() {
    return [
      {
        'title': 'Classifieds',
        'icon': Icons.category,
        'categoryName': 'Classifieds',
        'color': const Color(0xFF4285F4),
      },
      {
        'title': 'Motors',
        'icon': Icons.directions_car,
        'categoryName': 'Motors',
        'color': const Color(0xFF34A853),
      },
      {
        'title': 'Furniture & Garden',
        'icon': Icons.chair,
        'categoryName': 'Furniture & Garden',
        'color': const Color(0xFFEA4335),
      },
      {
        'title': 'Freshly Grown',
        'icon': Icons.eco,
        'categoryName': 'Freshly Grown',
        'color': const Color(0xFFFBBC04),
      },
      {
        'title': 'Property For Sale',
        'icon': Icons.home,
        'categoryName': 'Property For Sale',
        'color': const Color(0xFFFF6B35),
      },
      {
        'title': 'Property For Rent',
        'icon': Icons.house,
        'categoryName': 'Property For Rent',
        'color': const Color(0xFF9C27B0),
      },
    ];
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: CommonTextWidget(
                text: title,
                color: AppConstants.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                maxLines: 2,
                align: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
