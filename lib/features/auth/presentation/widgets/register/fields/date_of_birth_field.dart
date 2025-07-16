import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/inputs/text_field.dart';
import '../../../providers/auth_provider.dart';

class DateOfBirthField extends StatelessWidget {
  const DateOfBirthField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return CommonTextField(
          controller: TextEditingController(
            text:
                authProvider.selectedDateOfBirth?.toString().split(' ')[0] ??
                '',
          ),
          hintText: 'Date of Birth *',
          readOnly: true,
          onTap: () => _selectDateOfBirth(context, authProvider),
          prefixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: AppConstants.white,
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: AppConstants.white,
          ),
          validator: (value) => authProvider.selectedDateOfBirth == null
              ? 'Please select your date of birth'
              : null,
        );
      },
    );
  }

  Future<void> _selectDateOfBirth(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          authProvider.selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 13 * 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppConstants.appPrimaryColor,
              onPrimary: AppConstants.black,
              surface: AppConstants.black,
              onSurface: AppConstants.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      authProvider.setDateOfBirth(date);
    }
  }
}
