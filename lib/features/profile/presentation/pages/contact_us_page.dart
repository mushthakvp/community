import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/custom_tab_service.dart';
import '../../../../core/utils/extensions.dart';
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
                  title: 'Call Support - India',
                  subtitle: '+91 95670 77011',
                  onTap: () => _launchPhone(context, '+919567077011'),
                ),
                IOSSettingsItem(
                  icon: Icons.phone_outlined,
                  title: 'Call Support - UAE',
                  subtitle: '+971 50 328 0101',
                  onTap: () => _launchPhone(context, '+971503280101'),
                ),
                IOSSettingsItem(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'connect@liveraapp.com',
                  onTap: () => _launchEmail(context, 'connect@liveraapp.com'),
                ),
                IOSSettingsItem(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  subtitle:
                      'Livera Infocomm Limited Pallur PO Near Wadakancherry, Cheruthuruthy Rd, Desamangalam, Thrissur, Kerala 679532, India',
                  onTap: () => _launchMaps(context),
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

  Future<void> _launchPhone(BuildContext context, String phoneNumber) async {
    try {
      await CustomTabService.openPhone(phoneNumber);
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar(
          'Could not open phone dialer. Please try again.',
        );
      }
    }
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    try {
      await CustomTabService.openEmail(email);
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar(
          'Could not open email app. Please try again.',
        );
      }
    }
  }

  Future<void> _launchMaps(BuildContext context) async {
    try {
      const String address =
          'Livera Infocomm Limited Pallur PO Near Wadakancherry, Cheruthuruthy Rd, Desamangalam, Thrissur, Kerala 679532, India';
      await CustomTabService.openMaps(address);
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar('Could not open maps. Please try again.');
      }
    }
  }
}
