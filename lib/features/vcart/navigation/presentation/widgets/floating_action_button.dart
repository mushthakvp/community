import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';

class VCartFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? tooltip;

  const VCartFloatingActionButton({super.key, this.onPressed, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: VCartColors.primary,
      foregroundColor: VCartColors.onPrimary,
      elevation: 6,
      tooltip: tooltip ?? 'Marketplace',
      child: const Text('🛍️', style: TextStyle(fontSize: 24)),
    );
  }
}
