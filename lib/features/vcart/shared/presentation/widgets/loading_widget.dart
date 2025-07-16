import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/widgets/vcart_loading.dart';

class VCartLoadingWidget extends StatelessWidget {
  final String? message;
  final double? size;

  const VCartLoadingWidget({super.key, this.message, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VCartLoading(size: size ?? 32),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: VCartColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
