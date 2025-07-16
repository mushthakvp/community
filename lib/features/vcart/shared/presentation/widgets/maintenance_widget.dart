import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';

class VCartMaintenanceWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? imageUrl;

  const VCartMaintenanceWidget({
    super.key,
    this.title,
    this.subtitle,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(VCartConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                height: 200,
                width: 200,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.build_outlined,
                  size: 64,
                  color: VCartColors.warning,
                ),
              )
            else
              const Icon(
                Icons.build_outlined,
                size: 64,
                color: VCartColors.warning,
              ),
            const SizedBox(height: 24),
            Text(
              title ?? 'We\'re Undergoing Maintenance',
              style: const TextStyle(
                color: VCartColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle ??
                  'Our team is working hard to improve your experience. Please check back soon!',
              style: const TextStyle(
                color: VCartColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
