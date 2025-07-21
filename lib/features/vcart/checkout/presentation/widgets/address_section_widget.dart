import 'package:flutter/material.dart';

import '../../../address/domain/entities/address.dart';
import '../../../core/constants/vcart_colors.dart';
import 'address_card_widget.dart';

class AddressSectionWidget extends StatelessWidget {
  final List<Address> addresses;
  final Address? selectedAddress;
  final Function(Address) onAddressSelected;
  final VoidCallback onAddNewAddress;
  final bool isLoading;

  const AddressSectionWidget({
    super.key,
    required this.addresses,
    this.selectedAddress,
    required this.onAddressSelected,
    required this.onAddNewAddress,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 16),
        if (isLoading)
          _buildLoadingState()
        else if (addresses.isEmpty)
          _buildEmptyState()
        else
          _buildAddressList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Select Shipping Address",
            style: TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onAddNewAddress,
          icon: const Icon(Icons.add, color: VCartColors.primary, size: 20),
          label: const Text(
            "Add",
            style: TextStyle(
              color: VCartColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            side: const BorderSide(color: VCartColors.primary, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(color: VCartColors.primary),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: VCartColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VCartColors.border.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 48,
            color: VCartColors.textSecondary.withOpacity(0.7),
          ),
          const SizedBox(height: 12),
          const Text(
            'No addresses found',
            style: TextStyle(
              color: VCartColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add a delivery address to continue',
            style: TextStyle(color: VCartColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return AddressCardWidget(
          address: address,
          isSelected: selectedAddress?.id == address.id,
          onTap: () => onAddressSelected(address),
          showSelectionIndicator: true,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
