import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/custom_tab_service.dart';
import '../../../../core/utils/extensions.dart';
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
                  icon: Icons.people_outline,
                  title: 'Who we are',
                  subtitle: 'Learn about Livera Community App',
                  onTap: () => _showAboutDialog(context),
                ),
                IOSSettingsItem(
                  icon: Icons.rate_review_outlined,
                  title: 'Rate the App',
                  subtitle: 'Share your feedback',
                  onTap: () => _rateApp(context),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Who we are',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const SingleChildScrollView(
            child: Text(
              'The Livera Community App is a versatile platform designed to foster community engagement and provide a range of interactive services. Users can earn loyalty points through daily activities like spinning a wheel, participating in cooking contests, subscribing to social media channels, watching videos, and making purchases on the app\'s e-commerce platform. These points can be redeemed for discounts, additional spins, and other rewards.',
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppConstants.appPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        await CustomTabService.openAppStore(
          androidPackageId: 'com.livera.app',
          iosAppId: '1234567890',
        );
      } else if (Platform.isIOS) {
        await CustomTabService.openAppStore(
          androidPackageId: 'com.livera.app',
          iosAppId: '1234567890',
        );
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorSnackBar(
          'Could not open app store. Please try again.',
        );
      }
    }
  }
}
