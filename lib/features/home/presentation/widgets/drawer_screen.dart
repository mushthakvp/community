import 'package:fittor/fittor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: AppConstants.appPrimaryColor),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  _buildLogo(),
                  const SizedBox(height: 20),
                  _buildListTile(
                    context,
                    Icons.wb_sunny,
                    'Daily Spin',
                    onTap: () => context.push(RouteConstants.dailySpin),
                  ),
                  _buildListTile(
                    context,
                    Icons.casino,
                    'Spin and Earn',
                    onTap: () => context.push(RouteConstants.spinAndWin),
                  ),
                  _buildLanguageSelector(context),
                  const SizedBox(height: 20),
                  _buildSectionTitle(context, 'Preferences'),
                  const SizedBox(height: 15),
                  _buildListTile(
                    context,
                    Icons.privacy_tip,
                    'Privacy Policy',
                    onTap: () => context.push(RouteConstants.privacy),
                  ),
                  _buildListTile(
                    context,
                    Icons.info,
                    'About Us',
                    onTap: () => context.push(RouteConstants.aboutApp),
                  ),
                  _buildListTile(
                    context,
                    Icons.contact_support,
                    'Contact Us',
                    onTap: () => context.push(RouteConstants.contactUs),
                  ),
                ],
              ),
            ),
          ),
          10.h,
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppConstants.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _buildListTile(
              context,
              Icons.logout,
              'Logout',
              onTap: () => _showSignOutDialog(context),
            ),
          ),
          20.h,
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      height: 100,
      width: 200,
      child: const Center(
        child: Image(
          image: AssetImage('assets/animation/vivera-animation.gif'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title, {
    Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: DrawerLeadingWidget(icon: icon),
      title: CommonTextWidget(
        text: title,
        align: TextAlign.start,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppConstants.black,
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Row(
      children: [
        const DrawerLeadingWidget(icon: Icons.language),
        const SizedBox(width: 8),
        PopupMenuButton(
          color: const Color(0xffFFCB28),
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              AppConstants.appPrimaryColor,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          position: PopupMenuPosition.over,
          popUpAnimationStyle: const AnimationStyle(curve: Curves.easeInOut),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          onSelected: (_) {},
          surfaceTintColor: AppConstants.appPrimaryColor,
          icon: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonTextWidget(
                fontSize: 18,
                align: TextAlign.start,
                fontWeight: FontWeight.w500,
                color: AppConstants.black,
                text: 'Language',
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              height: 37,
              value: 'en',
              child: SizedBox(
                width: 100,
                child: CommonTextWidget(
                  text: 'English',
                  color: AppConstants.black,
                  fontSize: 18,
                  align: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const PopupMenuItem<String>(
              height: 37,
              value: 'hi',
              child: SizedBox(
                width: 100,
                child: CommonTextWidget(
                  text: 'Hindi',
                  color: AppConstants.black,
                  fontSize: 18,
                  align: TextAlign.start,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return CommonTextWidget(
      text: title,
      fontSize: 20,
      align: TextAlign.start,
      fontWeight: FontWeight.w700,
      color: AppConstants.black,
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
            onPressed: () => _handleSignOut(context),
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

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: AppConstants.appPrimaryColor),
        ),
      );
      await StorageService.clear();
      if (context.mounted) {
        final authProvider = context.read<AuthProvider>();
        await authProvider.logout();
      }
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      if (context.mounted) {
        context.go(RouteConstants.splash);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error signing out. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class DrawerContactWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;

  const DrawerContactWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xffFFCB28),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: 50,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xffF0B90A),
            ),
            child: Icon(icon, color: AppConstants.black, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonTextWidget(
                  overflow: TextOverflow.ellipsis,
                  text: title,
                  fontSize: 12,
                  align: TextAlign.start,
                  fontWeight: FontWeight.w400,
                  color: AppConstants.black,
                ),
                const SizedBox(height: 5),
                CommonTextWidget(
                  text: subTitle,
                  fontSize: 14,
                  align: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerLeadingWidget extends StatelessWidget {
  final IconData icon;
  const DrawerLeadingWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xffFFCB28),
      ),
      child: Icon(icon, color: AppConstants.black, size: 20),
    );
  }
}
