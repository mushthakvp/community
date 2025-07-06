import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../providers/vjob_home_provider.dart';

class ViewToggleWidget extends StatelessWidget {
  const ViewToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VJobHomeProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: provider.togglePostJob,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppConstants.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonTextWidget(
                  text: provider.isPostJob ? 'Posts' : 'Jobs',
                  color: AppConstants.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppConstants.white,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
