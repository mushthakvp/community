import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class CountryCodeSelector extends StatelessWidget {
  final String selectedCountryCode;
  final String selectedDialCode;
  final Function(String countryCode, String dialCode, String countryName)
  onCountrySelected;

  const CountryCodeSelector({
    super.key,
    required this.selectedCountryCode,
    required this.selectedDialCode,
    required this.onCountrySelected,
  });

  static const List<Map<String, String>> countries = [
    {'name': 'India', 'code': 'IN', 'dialCode': '+91', 'flag': '🇮🇳'},
    {
      'name': 'United Arab Emirates',
      'code': 'AE',
      'dialCode': '+971',
      'flag': '🇦🇪',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCountry = countries.firstWhere(
      (country) => country['code'] == selectedCountryCode,
      orElse: () => countries.first,
    );

    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextWidget(
              text: selectedCountry['dialCode'] ?? '+91',
              fontSize: 16,
              color: AppConstants.white,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: AppConstants.white.withOpacity(0.7),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              const SizedBox(height: 20),
              const CommonTextWidget(
                text: 'Select Country Code',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(height: 20),
              ...countries.map(
                (country) => _buildCountryItem(context, country),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildCountryItem(BuildContext context, Map<String, String> country) {
    final isSelected = country['code'] == selectedCountryCode;

    return InkWell(
      onTap: () {
        onCountrySelected(
          country['code']!,
          country['dialCode']!,
          country['name']!,
        );
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.appPrimaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppConstants.appPrimaryColor.withOpacity(0.3))
              : null,
        ),
        child: Row(
          children: [
            Text(country['flag']!, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget(
                    text: country['name']!,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.white,
                  ),
                  CommonTextWidget(
                    text: country['dialCode']!,
                    fontSize: 14,
                    color: AppConstants.white.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppConstants.appPrimaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
