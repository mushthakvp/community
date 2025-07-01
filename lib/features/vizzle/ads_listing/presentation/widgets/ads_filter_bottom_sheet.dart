import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/ads_filter_entity.dart';

class AdsFilterBottomSheet extends StatefulWidget {
  final AdsFilterEntity currentFilter;
  final Map<String, List<String>> filterOptions;
  final Function(AdsFilterEntity) onFilterChanged;
  final VoidCallback onFilterCleared;

  const AdsFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.filterOptions,
    required this.onFilterChanged,
    required this.onFilterCleared,
  });

  @override
  State<AdsFilterBottomSheet> createState() => _AdsFilterBottomSheetState();
}

class _AdsFilterBottomSheetState extends State<AdsFilterBottomSheet> {
  late AdsFilterEntity _tempFilter;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempFilter = widget.currentFilter;
    _minPriceController.text = _tempFilter.minPrice?.toString() ?? '';
    _maxPriceController.text = _tempFilter.maxPrice?.toString() ?? '';
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppConstants.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CommonTextWidget(
                  text: 'Filter Ads',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
                if (_tempFilter.hasActiveFilters)
                  GestureDetector(
                    onTap: _clearFilters,
                    child: CommonTextWidget(
                      text: 'Clear All',
                      fontSize: 14,
                      color: AppConstants.appPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationFilter(),
                  const SizedBox(height: 24),
                  _buildPriceRangeFilter(),
                  const SizedBox(height: 24),
                  _buildCategoryFilter(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppConstants.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Reset',
                    onPressed: _clearFilters,
                    backgroundColor: Colors.transparent,
                    textColor: AppConstants.white,
                    borderColor: AppConstants.white.withOpacity(0.3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Apply Filters',
                    onPressed: _applyFilters,
                    backgroundColor: AppConstants.appPrimaryColor,
                    textColor: AppConstants.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationFilter() {
    final locations = widget.filterOptions['locations'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Location',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: locations.map((location) {
            final isSelected = _tempFilter.location == location;
            return GestureDetector(
              onTap: () => _updateLocation(location),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppConstants.appPrimaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppConstants.appPrimaryColor
                        : AppConstants.white.withOpacity(0.3),
                  ),
                ),
                child: CommonTextWidget(
                  text: location,
                  fontSize: 12,
                  color: isSelected ? AppConstants.black : AppConstants.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Price Range',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPriceField(
                controller: _minPriceController,
                hint: 'Min Price',
                onChanged: (value) {
                  final price = double.tryParse(value);
                  _tempFilter = _tempFilter.copyWith(minPrice: price);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPriceField(
                controller: _maxPriceController,
                hint: 'Max Price',
                onChanged: (value) {
                  final price = double.tryParse(value);
                  _tempFilter = _tempFilter.copyWith(maxPrice: price);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstants.white.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: AppConstants.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    // This would be expanded based on the category type
    return const SizedBox.shrink();
  }

  void _updateLocation(String location) {
    setState(() {
      _tempFilter = _tempFilter.copyWith(
        location: _tempFilter.location == location ? null : location,
      );
    });
  }

  void _clearFilters() {
    setState(() {
      _tempFilter = const AdsFilterEntity();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  void _applyFilters() {
    widget.onFilterChanged(_tempFilter);
    Navigator.of(context).pop();
  }
}
