import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  final VCartProfileController controller;

  const ProfileHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.045),
      padding: EdgeInsets.symmetric(vertical: context.screenHeight * 0.015),
      width: double.infinity,
      decoration: BoxDecoration(
        color: VCartColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: VCartColors.border),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: context.screenWidth * 0.05,
            top: -context.screenHeight * 0.025,
            child: CircleAvatar(
              radius: context.screenHeight * 0.055,
              backgroundColor: VCartColors.surface,
              backgroundImage: controller.userProfilePicture != null
                  ? CachedNetworkImageProvider(
                      controller.userProfilePicture!.orPlaceholder,
                    )
                  : null,
              child: controller.userProfilePicture == null
                  ? Icon(
                      Icons.person,
                      size: context.screenHeight * 0.06,
                      color: VCartColors.textSecondary,
                    )
                  : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: context.screenWidth * 0.32,
              top: context.screenHeight * 0.01,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.userName,
                  style: TextStyle(
                    fontSize: context.screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: VCartColors.textPrimary,
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.005),
                Text(
                  controller.userEmail,
                  style: TextStyle(
                    fontSize: context.screenWidth * 0.04,
                    color: VCartColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.003),
                Text(
                  controller.userPhone,
                  style: TextStyle(
                    fontSize: context.screenWidth * 0.04,
                    color: VCartColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
