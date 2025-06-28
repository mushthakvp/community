import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../widgets/ios_settings_item.dart';
import '../widgets/ios_settings_section.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Contact Us'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Contact Information',
              items: [
                IOSSettingsItem(
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  subtitle: '+1 (800) 123-4567',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'contact@yourapp.com',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  subtitle: '123 App Street, Tech City, TC 12345',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            IOSSettingsSection(
              title: 'Business Hours',
              items: [
                IOSSettingsItem(
                  icon: Icons.access_time_outlined,
                  title: 'Monday - Friday',
                  subtitle: '9:00 AM - 6:00 PM',
                  onTap: () {},
                ),
                IOSSettingsItem(
                  icon: Icons.weekend_outlined,
                  title: 'Saturday - Sunday',
                  subtitle: '10:00 AM - 4:00 PM',
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
