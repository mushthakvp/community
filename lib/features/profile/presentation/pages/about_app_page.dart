import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../widgets/ios_settings_item.dart';
import '../widgets/ios_settings_section.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'About'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // App Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.app_registration,
                size: 50,
                color: AppConstants.black,
              ),
            ),
            const SizedBox(height: 20),
            IOSSettingsSection(
              items: [
                IOSSettingsItem(
                  icon: Icons.info_outline,
                  title: 'Version',
                  subtitle: '1.0.0 (Build 1)',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.update_outlined,
                  title: 'Check for Updates',
                  subtitle: 'Last checked: Today',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.bug_report_outlined,
                  title: 'Report a Bug',
                  subtitle: 'Help us improve the app',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.rate_review_outlined,
                  title: 'Rate the App',
                  subtitle: 'Share your feedback',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
