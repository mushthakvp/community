import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

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
      appBar: const CommonAppBar(title: 'Profile', showBackButton: false),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(profile: provider.profile),
                const SizedBox(height: 32),
                _buildMenuSection(context),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Menu',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppConstants.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              ProfileMenuItem(
                icon: Icons.edit_outlined,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => _navigateToEditProfile(context),
              ),
              ProfileMenuItem(
                icon: Icons.card_giftcard_outlined,
                title: 'Loyalty Points',
                subtitle: 'View and manage your loyalty points',
                onTap: () => _navigateToLoyaltyPoints(context),
              ),
              ProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () => _navigateToChangePassword(context),
              ),
              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () => _navigateToHelpSupport(context),
              ),
              ProfileMenuItem(
                icon: Icons.contact_mail_outlined,
                title: 'Contact Us',
                subtitle: 'Reach out to our team',
                onTap: () => _navigateToContactUs(context),
              ),
              ProfileMenuItem(
                icon: Icons.logout_outlined,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                onTap: () => _showSignOutDialog(context),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    context.push('/profile/edit');
  }

  void _navigateToLoyaltyPoints(BuildContext context) {
    context.push('/profile/loyalty-points');
  }

  void _navigateToChangePassword(BuildContext context) {
    context.push('/profile/change-password');
  }

  void _navigateToHelpSupport(BuildContext context) {
    context.push('/profile/help-support');
  }

  void _navigateToContactUs(BuildContext context) {
    context.push('/profile/contact-us');
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
            onPressed: () {
              Navigator.of(context).pop();
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
