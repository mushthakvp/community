import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class VizzleHomeSearchBar extends StatelessWidget {
  const VizzleHomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.vizzleSearch),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.78, -0.63),
            end: const Alignment(0.78, 0.63),
            colors: [
              AppConstants.white.withOpacity(0.12),
              AppConstants.white.withOpacity(0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search,
              color: AppConstants.white.withOpacity(0.5),
              size: 20,
            ),
            const SizedBox(width: 12),
            const CommonTextWidget(
              text: 'Search Products',
              color: AppConstants.white,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
