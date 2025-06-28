import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../widgets/ios_settings_item.dart';
import '../widgets/ios_settings_section.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Privacy'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Data Collection',
              items: [
                IOSSettingsItem(
                  icon: Icons.analytics_outlined,
                  title: 'Analytics Data',
                  subtitle: 'Help improve the app with usage data',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.location_on_outlined,
                  title: 'Location Services',
                  subtitle: 'Use location for personalized offers',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.cookie_outlined,
                  title: 'Cookies & Tracking',
                  subtitle: 'Manage tracking preferences',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Account Data',
              items: [
                IOSSettingsItem(
                  icon: Icons.download_outlined,
                  title: 'Download My Data',
                  subtitle: 'Get a copy of your account data',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  iconColor: Colors.red,
                  titleColor: Colors.red,
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
