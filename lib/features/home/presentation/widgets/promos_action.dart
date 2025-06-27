import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';

class PromosActions extends StatelessWidget {
  const PromosActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonTextWidget(
          text: 'Earn Rewards',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            context.push(RouteConstants.promos);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.appPrimaryColor.withOpacity(0.2),
                  AppConstants.appPrimaryColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonTextWidget(
                        text: 'Watch & Earn',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.white,
                      ),
                      const SizedBox(height: 8),
                      CommonTextWidget(
                        text: 'Watch videos and earn loyalty points',
                        fontSize: 14,
                        color: AppConstants.white.withOpacity(0.8),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.appPrimaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const CommonTextWidget(
                          text: 'Go to Promos',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppConstants.appPrimaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_circle_filled,
                    color: AppConstants.appPrimaryColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
