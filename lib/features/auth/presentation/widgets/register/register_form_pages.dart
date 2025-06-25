import 'package:flutter/material.dart';

import 'pages/account_setup_page.dart';
import 'pages/basic_info_page.dart';
import 'pages/personal_info_page.dart';

class RegisterFormPages extends StatelessWidget {
  final PageController pageController;
  final Function(int) onPageChanged;

  const RegisterFormPages({
    super.key,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: onPageChanged,
      children: const [BasicInfoPage(), PersonalInfoPage(), AccountSetupPage()],
    );
  }
}
