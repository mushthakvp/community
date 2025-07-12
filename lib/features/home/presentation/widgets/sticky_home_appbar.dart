import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/router/routers/chat_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/home_provider.dart';

class StickyHomeAppBar extends StatefulWidget {
  final VoidCallback onMenuPressed;

  const StickyHomeAppBar({super.key, required this.onMenuPressed});

  @override
  State<StickyHomeAppBar> createState() => _StickyHomeAppBarState();
}

class _StickyHomeAppBarState extends State<StickyHomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildMenuButton(),
                  const SizedBox(width: 16),
                  _buildWelcomeSection(context),
                ],
              ),
              _buildActionIcons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return GestureDetector(
      onTap: widget.onMenuPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: const Icon(Icons.menu, color: AppConstants.white, size: 20),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final userName =
            provider.userDetails?.name.capitalizeFirstLetter() ??
            "Community User";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CommonTextWidget(
              color: AppConstants.white,
              text: 'Welcome',
              align: TextAlign.start,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            CommonTextWidget(
              color: AppConstants.white,
              text: userName,
              align: TextAlign.start,
              fontSize: 13,
              fontWeight: FontWeight.w500,
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
          icon: Icons.chat_bubble_outline,
          onTap: () {
            _navigateToChat(context);
          },
        ),
        const SizedBox(width: 8),
        _buildNotificationButton(),
      ],
    );
  }

  void _navigateToChat(BuildContext context) {
    try {
      context.push(ChatRouter.vchatHomePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(icon, color: AppConstants.white, size: 20),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () {
        context.push(RouteConstants.notifications);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.white.withOpacity(0.2),
            width: 1,
          ),
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
