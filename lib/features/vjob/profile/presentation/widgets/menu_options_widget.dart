import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class MenuOptionsWidget extends StatelessWidget {
  const MenuOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuTile(
          title: 'My Jobs',
          icon: Icons.work_outline,
          onTap: () {
            context.pushNamed('vjobMyJobs');
          },
        ),
        const SizedBox(height: 20),
        _buildMenuTile(
          title: 'My Company',
          icon: Icons.business_outlined,
          onTap: () {
            context.pushNamed('vjobMyCompany');
          },
        ),
        const SizedBox(height: 20),
        _buildMenuTile(
          title: 'Create Job Post',
          icon: Icons.add_circle_outline,
          onTap: () {
            context.pushNamed('vjobCreateJob');
          },
        ),
        const SizedBox(height: 20),
        _buildMenuTile(
          title: 'My Posts',
          icon: Icons.article_outlined,
          onTap: () {
            context.pushNamed('vjobMyPosts');
          },
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CommonTextWidget(
              text: 'Quick Actions',
              color: AppConstants.white,
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed('vjobCreatePost');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppConstants.appPrimaryColor),
                  color: AppConstants.appPrimaryColor.withOpacity(0.2),
                ),
                child: const CommonTextWidget(
                  text: 'Create Post',
                  color: AppConstants.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xff161616),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: AppConstants.white, size: 20),
      ),
      title: CommonTextWidget(
        text: title,
        color: AppConstants.white,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
      trailing: const CircleAvatar(
        radius: 20,
        backgroundColor: Color(0xff161616),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: AppConstants.white,
        ),
      ),
    );
  }
}
