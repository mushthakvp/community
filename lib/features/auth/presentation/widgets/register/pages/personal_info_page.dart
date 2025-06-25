import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../providers/auth_provider.dart';
import '../../gender_selection.dart';
import '../fields/date_of_birth_field.dart';
import '../fields/location_fields.dart';
import '../fields/profession_field.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CommonTextWidget(
                text: 'Personal Details',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.white,
              ),
              const SizedBox(height: 8),
              CommonTextWidget(
                text: 'Tell us more about yourself',
                fontSize: 16,
                color: AppConstants.white.withOpacity(0.7),
              ),
              const SizedBox(height: 32),
              const GenderSelection(),
              const SizedBox(height: 24),
              const DateOfBirthField(),
              const SizedBox(height: 20),
              const ProfessionField(),
              const SizedBox(height: 20),
              const LocationFields(),
            ],
          );
        },
      ),
    );
  }
}
