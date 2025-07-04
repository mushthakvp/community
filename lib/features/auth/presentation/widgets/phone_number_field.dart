import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/inputs/text_field.dart';
import '../providers/auth_provider.dart';
import 'country_code_selector.dart';

class PhoneNumberField extends StatelessWidget {
  final String? Function(String?)? validator;

  const PhoneNumberField({super.key, this.validator});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppConstants.textFieldColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CountryCodeSelector(
                selectedCountryCode: authProvider.selectedCountryCode,
                selectedDialCode: authProvider.selectedDialCode,
                onCountrySelected:
                    (countryCode, dialCode, countryName, length) {
                      authProvider.setCountryCode(
                        countryCode: countryCode,
                        dialCode: dialCode,
                        countryName: countryName,
                        length: length,
                      );
                    },
              ),
              Expanded(
                child: CommonTextField(
                  maxLength: authProvider.selectedCountryLength,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  controller: authProvider.phoneController,
                  hintText: 'Phone Number *',
                  keyboardType: TextInputType.phone,
                  validator: validator,
                  borderColor: AppConstants.transparent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
