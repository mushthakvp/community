import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';

class RegisterProgress extends StatelessWidget {
  final int currentPage;

  const RegisterProgress({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
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

          const SizedBox(height: 12),

          // Step indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepIndicator('Basic Info', 0),
              _buildStepIndicator('Personal', 1),
              _buildStepIndicator('Account', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(String label, int stepIndex) {
    final isActive = stepIndex <= currentPage;
    final isCompleted = stepIndex < currentPage;

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive
                ? AppConstants.appPrimaryColor
                : AppConstants.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: AppConstants.black, size: 18)
                : Text(
                    '${stepIndex + 1}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? AppConstants.black
                          : AppConstants.white.withOpacity(0.7),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive
                ? AppConstants.appPrimaryColor
                : AppConstants.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
