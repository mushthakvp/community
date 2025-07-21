import 'package:flutter/material.dart';

import '../../../address/domain/entities/address.dart';
import '../../../core/constants/vcart_colors.dart';

class AddressCardWidget extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showSelectionIndicator;
  final bool showActions;

  const AddressCardWidget({
    super.key,
    required this.address,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showSelectionIndicator = false,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VCartColors.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? VCartColors.primary
                : VCartColors.border.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (showSelectionIndicator) _buildSelectionIndicator(),
                if (showSelectionIndicator) const SizedBox(width: 12),
                Expanded(child: _buildAddressContent()),
                if (showActions) _buildActions(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? VCartColors.primary : VCartColors.border,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: VCartColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildAddressContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: VCartColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                address.displayTitle,
                style: const TextStyle(
                  color: VCartColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          address.name,
          style: const TextStyle(
            color: VCartColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address.phone,
          style: const TextStyle(
            color: VCartColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          address.formattedAddress,
          style: const TextStyle(
            color: VCartColors.textSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                border: Border.all(color: VCartColors.primary, width: 1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: VCartColors.primary,
              ),
            ),
          ),
        if (onDelete != null) const SizedBox(width: 8),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                color: VCartColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 16,
                color: VCartColors.onPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
