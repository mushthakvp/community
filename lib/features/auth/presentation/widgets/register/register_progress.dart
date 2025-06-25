import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';

class RegisterProgress extends StatelessWidget {
  final int currentPage;

  const RegisterProgress({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= currentPage;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? AppConstants.appPrimaryColor
                    : AppConstants.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
