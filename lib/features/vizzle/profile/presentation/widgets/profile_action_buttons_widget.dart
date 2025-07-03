import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class ProfileActionButtonsWidget extends StatelessWidget {
  const ProfileActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context: context,
              icon: Icons.favorite_outline,
              label: 'Saved',
              onTap: () {
                // Navigate to saved ads
                debugPrint('Navigate to saved ads');
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context: context,
              icon: Icons.history,
              label: 'Recently viewed',
              onTap: () {
                // Navigate to recently viewed
                debugPrint('Navigate to recently viewed');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppConstants.white, size: 20),
            const SizedBox(width: 8),
            CommonTextWidget(
              text: label,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
          ],
        ),
      ),
    );
  }
}
