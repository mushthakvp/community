import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';

class SpinMainPage extends StatelessWidget {
  const SpinMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Spin Games', showBackButton: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.black, Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                const SizedBox(height: 20),
                CommonTextWidget(
                  text: 'Choose Your Game',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 12),
                CommonTextWidget(
                  text: 'Try your luck with our exciting spin games',
                  fontSize: 16,
                  color: Colors.grey.shade400,
                  align: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Game cards
                Expanded(
                  child: Column(
                    children: [
                      // Daily Spin Card
                      _buildGameCard(
                        context: context,
                        title: 'Daily Spin',
                        subtitle: 'Spin once per day for free rewards',
                        icon: Icons.wb_sunny,
                        color: Colors.orange,
                        onTap: () =>
                            Navigator.pushNamed(context, '/daily-spin'),
                        features: [
                          'Free daily spin',
                          'Loyalty points',
                          'Special coupons',
                          'Daily rewards',
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Spin & Win Card
                      _buildGameCard(
                        context: context,
                        title: 'Spin & Win',
                        subtitle: 'Unlimited spins with loyalty points',
                        icon: Icons.casino,
                        color: AppConstants.appPrimaryColor,
                        onTap: () =>
                            Navigator.pushNamed(context, '/spin-and-win'),
                        features: [
                          'Unlimited spins',
                          'Bigger rewards',
                          'Premium prizes',
                          'Bonus rounds',
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // History button
                PrimaryButton(
                  text: 'View History',
                  onPressed: () =>
                      Navigator.pushNamed(context, '/spin-history'),
                  backgroundColor: Colors.transparent,
                  borderColor: AppConstants.appPrimaryColor,
                  textColor: AppConstants.appPrimaryColor,
                  height: 48,
                  width: double.infinity,
                  prefix: const Icon(
                    Icons.history,
                    color: AppConstants.appPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required List<String> features,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget(
                        text: title,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      CommonTextWidget(
                        text: subtitle,
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 20),
              ],
            ),

            const SizedBox(height: 16),

            // Features
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features.map((feature) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: color, size: 14),
                      const SizedBox(width: 4),
                      CommonTextWidget(
                        text: feature,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
