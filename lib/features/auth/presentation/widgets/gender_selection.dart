import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/auth_provider.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonTextWidget(
              text: 'Gender',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildGenderOption('Male', authProvider),
                const SizedBox(width: 16),
                _buildGenderOption('Female', authProvider),
                const SizedBox(width: 16),
                _buildGenderOption('Other', authProvider),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenderOption(String gender, AuthProvider authProvider) {
    final isSelected = authProvider.selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () => authProvider.setGender(gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppConstants.appPrimaryColor.withOpacity(0.2)
                : AppConstants.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppConstants.appPrimaryColor
                  : AppConstants.white.withOpacity(0.3),
            ),
          ),
          child: CommonTextWidget(
            text: gender,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? AppConstants.appPrimaryColor
                : AppConstants.white,
            align: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
