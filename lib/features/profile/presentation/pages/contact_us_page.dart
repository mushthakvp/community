import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  title: 'Call Support - India',
                  subtitle: '+91 95670 77011',
                  onTap: () => _launchPhone('+919567077011'),
                ),
                IOSSettingsItem(
                  icon: Icons.phone_outlined,
                  title: 'Call Support - UAE',
                  subtitle: '+971 50 328 0101',
                  onTap: () => _launchPhone('+971503280101'),
                ),
                IOSSettingsItem(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  subtitle: 'connect@liveraapp.com',
                  onTap: () => _launchEmail('connect@liveraapp.com'),
                ),
                IOSSettingsItem(
                  icon: Icons.location_on_outlined,
                  title: 'Address',
                  subtitle:
                      'Livera Infocomm Limited Pallur PO Near Wadakancherry, Cheruthuruthy Rd, Desamangalam, Thrissur, Kerala 679532, India',
                  onTap: () => _launchMaps(),
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

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(phoneUri)) {
      throw Exception('Could not launch phone dialer');
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch email');
    }
  }

  Future<void> _launchMaps() async {
    const String address =
        'Livera Infocomm Limited Pallur PO Near Wadakancherry, Cheruthuruthy Rd, Desamangalam, Thrissur, Kerala 679532, India';
    final Uri mapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    if (!await launchUrl(mapsUri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch maps');
    }
  }
}
