import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livera/core/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/routers/chat_router.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/home_provider.dart';

class StickyHomeAppBar extends StatefulWidget {
  const StickyHomeAppBar({super.key});

  @override
  State<StickyHomeAppBar> createState() => _StickyHomeAppBarState();
}

class _StickyHomeAppBarState extends State<StickyHomeAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWelcomeSection(context),
              _buildActionIcons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final userName =
            provider.userDetails?.name.capitalizeFirstLetter() ??
            "Community User";
        return Row(
          children: [
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonTextWidget(
                  color: AppConstants.white,
                  text: 'Welcome',
                  align: TextAlign.start,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                CommonTextWidget(
                  color: AppConstants.white,
                  text: userName,
                  align: TextAlign.start,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionIcons(BuildContext context) {
    return Row(
      children: [
        _buildIconButton(
          icon: AppConstants.chatIcon,
          onTap: () => _navigateToChat(context),
        ),
        const SizedBox(width: 8),
        _buildNotificationButton(),
      ],
    );
  }

  void _navigateToChat(BuildContext context) {
    try {
      log('Navigating to chat...');
      ChatRouter.navigateToChatHome(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chat feature is currently unavailable'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildIconButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SvgPicture.string(
          icon,
          height: 20,
          width: 20,
          colorFilter: const ColorFilter.mode(
            AppConstants.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to notifications
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2), // Subtle transparent background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Icon(
              Icons.notifications_outlined,
              color: AppConstants.white,
              size: 20,
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppConstants.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
