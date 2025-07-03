import 'package:flutter/material.dart';

import '../../../../../core/widgets/common/text_widget.dart';
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
      children: [
        // Page 0: Basic Info
        Container(
          key: const ValueKey('basic_info_page'),
          child: const BasicInfoPage(),
        ),

        // Page 1: Personal Info
        Container(
          key: const ValueKey('personal_info_page'),
          child: const PersonalInfoPage(),
        ),

        // Page 2: Account Setup
        Container(
          key: const ValueKey('account_setup_page'),
          child: const AccountSetupPage(),
        ),
      ],
    );
  }
}

// Create a debug version to verify the issue
class DebugRegisterFormPages extends StatefulWidget {
  final PageController pageController;
  final Function(int) onPageChanged;

  const DebugRegisterFormPages({
    super.key,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  State<DebugRegisterFormPages> createState() => _DebugRegisterFormPagesState();
}

class _DebugRegisterFormPagesState extends State<DebugRegisterFormPages> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Debug info
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.red.withOpacity(0.1),
          child: CommonTextWidget(
            text: 'DEBUG: Current Page = $_currentPage',
            fontSize: 12,
            color: Colors.red,
          ),
        ),

        // Main PageView
        Expanded(
          child: PageView(
            controller: widget.pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
              widget.onPageChanged(page);
            },
            children: [
              // Page 0: Basic Info
              Container(
                key: const ValueKey('basic_info_page'),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue.withOpacity(0.1),
                      child: const CommonTextWidget(
                        text: 'PAGE 0: BASIC INFO',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Expanded(child: BasicInfoPage()),
                  ],
                ),
              ),

              // Page 1: Personal Info
              Container(
                key: const ValueKey('personal_info_page'),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.green.withOpacity(0.1),
                      child: const CommonTextWidget(
                        text: 'PAGE 1: PERSONAL INFO',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Expanded(child: PersonalInfoPage()),
                  ],
                ),
              ),

              // Page 2: Account Setup
              Container(
                key: const ValueKey('account_setup_page'),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange.withOpacity(0.1),
                      child: const CommonTextWidget(
                        text: 'PAGE 2: ACCOUNT SETUP (PASSWORD)',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Expanded(child: AccountSetupPage()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
