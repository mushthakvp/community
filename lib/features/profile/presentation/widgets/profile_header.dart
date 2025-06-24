import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity? user;

  const ProfileHeader({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppConstants.appPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: AppConstants.black,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: user?.name ?? 'User Name',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.white,
                ),
                CommonTextWidget(
                  text: user?.email ?? 'user@example.com',
                  fontSize: 14,
                  color: AppConstants.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
