import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../controllers/search_controller.dart';

class RecentSearchesDropdown extends StatelessWidget {
  final VCartSearchController controller;
  final Function(String) onSearchTap;

  const RecentSearchesDropdown({
    super.key,
    required this.controller,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.recentSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: VCartColors.surface,
        border: Border.all(color: VCartColors.border, width: 0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: controller.recentSearches.length,
        separatorBuilder: (context, index) =>
            const Divider(color: VCartColors.border, height: 1),
        itemBuilder: (context, index) {
          final search = controller.recentSearches[index];
          return InkWell(
            onTap: () => onSearchTap(search.searchTerm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: VCartColors.textPrimary.withOpacity(0.15),
                    size: 20,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      search.searchTerm,
                      style: TextStyle(
                        fontSize: 13,
                        color: VCartColors.textPrimary.withOpacity(0.6),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.north_west,
                    color: VCartColors.textSecondary.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
