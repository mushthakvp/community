import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class PromosActions extends StatelessWidget {
  const PromosActions({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // context.pushNamed('/promos');
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConstants.white.withOpacity(0.1)),
        ),
        child: const CommonTextWidget(
          text: 'Goto Promos',
          fontSize: 16,
          color: AppConstants.white,
          align: TextAlign.center,
        ),
      ),
    );
  }
}
