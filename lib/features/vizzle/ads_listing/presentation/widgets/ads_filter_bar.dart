import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/ads_filter_entity.dart';
import '../pages/ads_listing_page.dart';
import 'ads_filter_bottom_sheet.dart';
import 'ads_sort_bottom_sheet.dart';

class AdsFilterBar extends StatelessWidget {
  final AdsFilterEntity currentFilter;
  final Map<String, List<String>> filterOptions;
  final Function(AdsFilterEntity) onFilterChanged;
  final VoidCallback onFilterCleared;
  final Function(AdsViewType) onViewTypeChanged;
  final AdsViewType currentViewType;

  const AdsFilterBar({
    super.key,
    required this.currentFilter,
    required this.filterOptions,
    required this.onFilterChanged,
    required this.onFilterCleared,
    required this.onViewTypeChanged,
    required this.currentViewType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Filter button
        Expanded(
          child: _FilterButton(
            currentFilter: currentFilter,
            filterOptions: filterOptions,
            onFilterChanged: onFilterChanged,
            onFilterCleared: onFilterCleared,
          ),
        ),

        const SizedBox(width: 8),

        // Sort button
        _SortButton(
          currentSort: currentFilter.sortBy,
          onSortChanged: (sort) {
            onFilterChanged(currentFilter.copyWith(sortBy: sort));
          },
        ),

        const SizedBox(width: 8),

        // View type toggle
        _ViewTypeToggle(
          currentViewType: currentViewType,
          onViewTypeChanged: onViewTypeChanged,
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final AdsFilterEntity currentFilter;
  final Map<String, List<String>> filterOptions;
  final Function(AdsFilterEntity) onFilterChanged;
  final VoidCallback onFilterCleared;

  const _FilterButton({
    required this.currentFilter,
    required this.filterOptions,
    required this.onFilterChanged,
    required this.onFilterCleared,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = currentFilter.hasActiveFilters;

    return GestureDetector(
      onTap: () => _showFilterBottomSheet(context),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: hasActiveFilters
              ? AppConstants.appPrimaryColor.withOpacity(0.15)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasActiveFilters
                ? AppConstants.appPrimaryColor
                : AppConstants.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune,
              color: hasActiveFilters
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white.withOpacity(0.6),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              hasActiveFilters ? 'Filtered' : 'Filter',
              style: TextStyle(
                color: hasActiveFilters
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hasActiveFilters) ...[
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppConstants.appPrimaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AdsFilterBottomSheet(
        currentFilter: currentFilter,
        filterOptions: filterOptions,
        onFilterChanged: onFilterChanged,
        onFilterCleared: onFilterCleared,
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final AdsFilterSort currentSort;
  final Function(AdsFilterSort) onSortChanged;

  const _SortButton({required this.currentSort, required this.onSortChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSortBottomSheet(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.sort,
          color: AppConstants.white.withOpacity(0.6),
          size: 16,
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AdsSortBottomSheet(
        currentSort: currentSort,
        onSortChanged: onSortChanged,
      ),
    );
  }
}

class _ViewTypeToggle extends StatelessWidget {
  final AdsViewType currentViewType;
  final Function(AdsViewType) onViewTypeChanged;

  const _ViewTypeToggle({
    required this.currentViewType,
    required this.onViewTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppConstants.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ViewTypeButton(
            icon: Icons.grid_view,
            isSelected: currentViewType == AdsViewType.grid,
            onTap: () => onViewTypeChanged(AdsViewType.grid),
          ),
          Container(
            width: 1,
            height: 20,
            color: AppConstants.white.withOpacity(0.2),
          ),
          _ViewTypeButton(
            icon: Icons.list,
            isSelected: currentViewType == AdsViewType.list,
            onTap: () => onViewTypeChanged(AdsViewType.list),
          ),
        ],
      ),
    );
  }
}

class _ViewTypeButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewTypeButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.appPrimaryColor.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: isSelected
              ? AppConstants.appPrimaryColor
              : AppConstants.white.withOpacity(0.6),
          size: 16,
        ),
      ),
    );
  }
}
