import 'package:flutter/material.dart';

import '../../../checkout/presentation/widgets/address_card_widget.dart';
import '../../domain/entities/address.dart';

class AddressListItem extends StatelessWidget {
  final Address address;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isLoading;

  const AddressListItem({
    super.key,
    required this.address,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AddressCardWidget(
      address: address,
      onEdit: isLoading ? null : onEdit,
      onDelete: isLoading ? null : onDelete,
      showActions: true,
    );
  }
}
