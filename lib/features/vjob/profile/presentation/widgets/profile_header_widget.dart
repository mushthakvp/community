import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserEntity user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppConstants.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: CircleAvatar(
              radius: 58,
              backgroundImage: user.profileImage != null
                  ? NetworkImage(user.profileImage!)
                  : null,
              child: user.profileImage == null
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: AppConstants.white.withOpacity(0.7),
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                text: user.name,
                color: AppConstants.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: user.email,
                color: AppConstants.white.withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.w300,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
