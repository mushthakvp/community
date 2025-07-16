import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class ChipSelectorWidget extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final Function(String) onItemToggled;
  final bool allowMultiple;

  const ChipSelectorWidget({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onItemToggled,
    this.allowMultiple = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => _buildChip(item)).toList(),
    );
  }

  Widget _buildChip(String item) {
    final isSelected = selectedItems.contains(item);

    return GestureDetector(
      onTap: () => onItemToggled(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.appPrimaryColor.withOpacity(0.2)
              : const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppConstants.appPrimaryColor
                : AppConstants.white.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.add_circle_outline,
                key: ValueKey(isSelected),
                size: 16,
                color: isSelected
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            CommonTextWidget(
              text: item,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white,
            ),
          ],
        ),
      ),
    );
  }
}
