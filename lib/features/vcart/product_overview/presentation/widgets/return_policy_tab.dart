import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';

class ReturnPolicyTab extends StatelessWidget {
  final String policy;

  const ReturnPolicyTab({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    return Text(
      policy.isNotEmpty ? policy : 'No return policy information available',
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: VCartColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
