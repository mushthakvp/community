import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../../../core/utils/vcart_helpers.dart';
import '../../domain/entities/search_section.dart';

class SectionsGrid extends StatelessWidget {
  final List<SearchSection> sections;
  final Function(SearchSection) onSectionTap;

  const SectionsGrid({
    super.key,
    required this.sections,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: VCartHelpers.calculateChildAspectRatio(
          context.screenWidth,
          context.screenHeight,
          multiplier: 1.5,
        ),
      ),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        return GestureDetector(
          onTap: () => onSectionTap(section),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: VCartColors.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: VCartColors.border, width: 0.1),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: VCartColors.background,
                  backgroundImage: CachedNetworkImageProvider(
                    section.imageUrl.orPlaceholder,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    section.name,
                    style: const TextStyle(
                      fontSize: 14,
                      color: VCartColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
