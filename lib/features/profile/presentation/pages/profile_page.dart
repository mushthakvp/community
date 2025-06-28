import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/profile_provider.dart';
import '../widgets/ios_settings_item.dart';
import '../widgets/ios_settings_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(
        title: 'Profile',
        showBackButton: false,
        centerTitle: false,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                IOSSettingsSection(
                  title: 'Account',
                  items: [
                    IOSSettingsItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      onTap: () => context.push(RouteConstants.editProfile),
                    ),
                    IOSSettingsItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () => context.push(RouteConstants.changePassword),
                    ),
                    IOSSettingsItem(
                      icon: Icons.card_giftcard_outlined,
                      title: 'Loyalty Points',
                      subtitle: 'View and manage your rewards',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.appPrimaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CommonTextWidget(
                          text: '${provider.profile?.loyaltyPoints ?? 0}',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.appPrimaryColor,
                        ),
                      ),
                      onTap: () => context.push(RouteConstants.loyaltyPoints),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Preferences Section
                IOSSettingsSection(
                  title: 'Preferences',
                  items: [
                    IOSSettingsItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      subtitle: 'App preferences and configuration',
                      onTap: () => context.push(RouteConstants.settings),
                    ),
                    IOSSettingsItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage notification preferences',
                      onTap: () => context.push(RouteConstants.notifications),
                    ),
                    IOSSettingsItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy',
                      subtitle: 'Privacy and data settings',
                      onTap: () => context.push(RouteConstants.privacy),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                IOSSettingsSection(
                  title: 'Support',
                  items: [
                    IOSSettingsItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: () => context.push(RouteConstants.helpSupport),
                    ),
                    IOSSettingsItem(
                      icon: Icons.contact_mail_outlined,
                      title: 'Contact Us',
                      subtitle: 'Reach out to our team',
                      onTap: () => context.push(RouteConstants.contactUs),
                    ),
                    IOSSettingsItem(
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      subtitle: 'Read our terms of service',
                      onTap: () => context.push(RouteConstants.termsConditions),
                    ),
                    IOSSettingsItem(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'App version and information',
                      onTap: () => context.push(RouteConstants.aboutApp),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sign Out Section
                IOSSettingsSection(
                  items: [
                    IOSSettingsItem(
                      icon: Icons.logout_outlined,
                      title: 'Sign Out',
                      subtitle: 'Sign out of your account',
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      onTap: () => _showSignOutDialog(context),
                    ),
                  ],
                ),

                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CommonTextWidget(
          text: 'Sign Out',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: const CommonTextWidget(
          text: 'Are you sure you want to sign out?',
          fontSize: 16,
          color: AppConstants.white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CommonTextWidget(
              text: 'Cancel',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
          ),
          TextButton(
            onPressed: () async {
              await StorageService.clearSecureStorage();
              context.go(RouteConstants.login);
            },
            child: const CommonTextWidget(
              text: 'Sign Out',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
