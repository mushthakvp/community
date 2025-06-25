import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class GuestModeButton extends StatelessWidget {
  const GuestModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 2000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.white.withOpacity(0.1),
                  AppConstants.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppConstants.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => _handleGuestMode(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppConstants.white.withOpacity(0.8),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      CommonTextWidget(
                        text: 'Guest Mode',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.white.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleGuestMode(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CommonTextWidget(
          text: 'Continue as Guest?',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: CommonTextWidget(
          text:
              'You\'ll have limited access to features. You can create an account anytime.',
          fontSize: 14,
          color: AppConstants.white.withOpacity(0.8),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CommonTextWidget(
              text: 'Cancel',
              fontSize: 14,
              color: AppConstants.white.withOpacity(0.6),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(RouteConstants.home);
            },
            child: const CommonTextWidget(
              text: 'Continue',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
