import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class EmptyPostsWidget extends StatelessWidget {
  final String message;

  const EmptyPostsWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.post_add_outlined,
                size: 56,
                color: AppConstants.appPrimaryColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'No Posts Found',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CommonTextWidget(
              text: message,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
