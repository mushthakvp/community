import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              title: 'Privacy Policies',
              items: [
                IOSSettingsItem(
                  icon: Icons.policy_outlined,
                  title: 'Vizzle',
                  subtitle: 'Vizzle privacy policy',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vizzle-policy'),
                ),
                IOSSettingsItem(
                  icon: Icons.policy_outlined,
                  title: 'VHub',
                  subtitle: 'VHub privacy policy',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vhub-policy'),
                ),
                IOSSettingsItem(
                  icon: Icons.policy_outlined,
                  title: 'VCart',
                  subtitle: 'VCart privacy policy',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vcart-policy'),
                ),
                IOSSettingsItem(
                  icon: Icons.policy_outlined,
                  title: 'VCash',
                  subtitle: 'VCash privacy policy',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vcash-policy'),
                ),
                IOSSettingsItem(
                  icon: Icons.policy_outlined,
                  title: 'VCook',
                  subtitle: 'VCook privacy policy',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vcook-policy'),
                ),
                IOSSettingsItem(
                  icon: Icons.policy_outlined,
                  title: 'VChat',
                  subtitle: 'VChat privacy policy',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vchat-policy'),
                ),
                IOSSettingsItem(
                  icon: Icons.policy_outlined,
                  title: 'VOne',
                  subtitle: 'VOne privacy policy',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vone-policy'),
                ),
                IOSSettingsItem(
                  icon: Icons.policy_outlined,
                  title: 'VCare',
                  subtitle: 'VCare privacy policy',
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/vcare-policy'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Account Data',
              items: [
                IOSSettingsItem(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  iconColor: Colors.red,
                  titleColor: Colors.red,
                  onTap: () =>
                      _launchURL('https://www.liveraapp.com/delete-account'),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
