import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/image_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/user_entity.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserEntity? user;

  const ProfileHeaderWidget({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: user?.profileImage.isNotEmpty == true
                  ? CommonImageWidget(
                      imageUrl: user!.profileImage,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppConstants.white.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppConstants.white.withOpacity(0.6),
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: user?.name ?? 'User',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: AppConstants.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    CommonTextWidget(
                      text: 'Joined ${user?.joinedDateDisplay ?? 'recently'}',
                      fontSize: 14,
                      color: AppConstants.white.withOpacity(0.6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
