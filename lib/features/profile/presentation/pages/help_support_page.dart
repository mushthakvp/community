import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../widgets/ios_settings_item.dart';
import '../widgets/ios_settings_section.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Help & Support'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Get Help',
              items: [
                IOSSettingsItem(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  subtitle: 'Frequently asked questions',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.chat_outlined,
                  title: 'Live Chat',
                  subtitle: 'Chat with our support team',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.call_outlined,
                  title: 'Call Support',
                  subtitle: '+1 (800) 123-4567',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  subtitle: 'support@yourapp.com',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Resources',
              items: [
                IOSSettingsItem(
                  icon: Icons.video_library_outlined,
                  title: 'Video Tutorials',
                  subtitle: 'Learn how to use the app',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.article_outlined,
                  title: 'User Guide',
                  subtitle: 'Detailed app documentation',
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
