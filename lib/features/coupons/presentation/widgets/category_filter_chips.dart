// lib/features/coupons/presentation/widgets/category_filter_chips.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/coupon_provider.dart';

class CategoryFilterChips extends StatefulWidget {
  const CategoryFilterChips({super.key});

  @override
  State<CategoryFilterChips> createState() => _CategoryFilterChipsState();
}

class _CategoryFilterChipsState extends State<CategoryFilterChips>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponProvider>(
      builder: (context, provider, child) {
        if (provider.categories.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CommonTextWidget(
                  text: 'Categories',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
                const Spacer(),
                if (provider.selectedCategoryId != 'all')
                  GestureDetector(
                    onTap: () => provider.selectCategory('all'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.clear, color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          const CommonTextWidget(
                            text: 'Clear',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _animationController,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: _buildCategoryGrid(provider),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryGrid(CouponProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: provider.categories.length,
      itemBuilder: (context, index) {
        final category = provider.categories[index];
        final isSelected = category.id == provider.selectedCategoryId;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildCategoryChip(category.name, isSelected, () {
                provider.selectCategory(category.id);
              }),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryChip(String name, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.defaultAnimationDuration,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppConstants.appPrimaryColor,
                    AppConstants.appPrimaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppConstants.appPrimaryColor
                : AppConstants.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.appPrimaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppConstants.black.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(
                  _getCategoryIcon(name),
                  color: AppConstants.black,
                  size: 16,
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: CommonTextWidget(
                  text: name,
                  color: isSelected ? AppConstants.black : AppConstants.white,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                  maxLines: 1,
                  align: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'all':
        return Icons.apps;
      case 'food':
      case 'restaurant':
      case 'dining':
        return Icons.restaurant;
      case 'fashion':
      case 'clothing':
        return Icons.checkroom;
      case 'electronics':
      case 'tech':
        return Icons.devices;
      case 'travel':
      case 'flight':
        return Icons.flight;
      case 'beauty':
      case 'cosmetics':
        return Icons.face;
      case 'health':
      case 'medical':
        return Icons.health_and_safety;
      case 'books':
      case 'education':
        return Icons.book;
      case 'grocery':
      case 'shopping':
        return Icons.shopping_cart;
      case 'entertainment':
      case 'movies':
        return Icons.movie;
      case 'sports':
      case 'fitness':
        return Icons.fitness_center;
      case 'home':
      case 'furniture':
        return Icons.home;
      case 'automotive':
      case 'car':
        return Icons.directions_car;
      default:
        return Icons.category;
    }
  }
}
