import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: 'Continue with Google',
          onPressed: () {
            // Implement Google Sign In
          },
          backgroundColor: Colors.white,
          textColor: Colors.black,
          height: 56,
          prefix: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://developers.google.com/identity/images/g-logo.png',
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'Continue with Apple',
          onPressed: () {
            // Implement Apple Sign In
          },
          backgroundColor: Colors.black,
          borderColor: AppConstants.white.withOpacity(0.3),
          textColor: Colors.white,
          height: 56,
          prefix: const Icon(Icons.apple, color: Colors.white, size: 20),
        ),
      ],
    );
  }
}
