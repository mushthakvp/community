import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../domain/entities/section_category_item.dart';

class SectionCategoryGrid extends StatelessWidget {
  final List<SectionCategoryItem> categories;
  final String sectionId;
  final Function(SectionCategoryItem) onCategoryTap;

  const SectionCategoryGrid({
    super.key,
    required this.categories,
    required this.sectionId,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: List.generate(categories.length, (index) {
        final category = categories[index];
        final height = 100 + (index % 4) * 60.0;

        return StaggeredGridTile.count(
          crossAxisCellCount: _getCrossAxisCount(index),
          mainAxisCellCount: _getMainAxisCount(index),
          child: SectionCategoryItems(
            category: category,
            height: height,
            onTap: () => onCategoryTap(category),
          ),
        );
      }),
    );
  }

  int _getCrossAxisCount(int index) {
    switch (index % 6) {
      case 0:
      case 1:
      case 3:
      case 4:
        return 2;
      case 2:
      case 5:
        return 4;
      default:
        return 2;
    }
  }

  int _getMainAxisCount(int index) {
    switch (index % 6) {
      case 5:
        return 1;
      default:
        return 2;
    }
  }
}

class SectionCategoryItems extends StatelessWidget {
  final SectionCategoryItem category;
  final double height;
  final VoidCallback onTap;

  const SectionCategoryItems({
    super.key,
    required this.category,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.2, 0.55, 0.6, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.darken,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(category.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                category.name,
                style: const TextStyle(
                  color: VCartColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
