import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/home_provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildWelcomeSection(context), _buildActionIcons(context)],
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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: AppConstants.white, size: 28),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonTextWidget(
                  color: AppConstants.white,
                  text: 'Welcome',
                  align: TextAlign.start,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                CommonTextWidget(
                  color: AppConstants.white,
                  text: userName,
                  align: TextAlign.start,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
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
        _buildIconButton(icon: AppConstants.chatIcon, onTap: () {}),
        const SizedBox(width: 8),
        _buildNotificationButton(),
      ],
    );
  }

  Widget _buildIconButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: SvgPicture.string(
          icon,
          height: 24,
          width: 24,
          color: AppConstants.white,
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to notifications
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppConstants.white,
              size: 24,
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppConstants.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
