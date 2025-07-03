import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/spin_provider.dart';
import '../widgets/spin_result_dialog.dart';
import '../widgets/spin_wheel_widget.dart';

class DailySpinPage extends StatefulWidget {
  const DailySpinPage({super.key});

  @override
  State<DailySpinPage> createState() => _DailySpinPageState();
}

class _DailySpinPageState extends State<DailySpinPage> {
  static const String spinType = 'daily_spin';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpinProvider>().initializeSpin(spinType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Daily Spin', showBackButton: true),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.black, Color(0xFF1A1A1A)],
          ),
        ),
        child: Consumer<SpinProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: LoadingWidget());
            }

            if (provider.hasError) {
              return _buildErrorState(provider);
            }

            return _buildSpinInterface(provider);
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(SpinProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: 'Something went wrong',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: provider.errorMessage ?? 'Please try again',
              fontSize: 14,
              color: Colors.grey.shade400,
              align: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Retry',
              onPressed: () => provider.initializeSpin(spinType),
              backgroundColor: AppConstants.appPrimaryColor,
              textColor: Colors.white,
              width: 120,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpinInterface(SpinProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header info
            _buildHeaderInfo(provider),

            const SizedBox(height: 32),

            // Spin wheel
            Expanded(
              child: Center(
                child: provider.hasSpinOptions
                    ? _buildSpinWheel(provider)
                    : _buildNoSpinAvailable(),
              ),
            ),

            const SizedBox(height: 32),

            // Action button
            _buildActionButton(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(SpinProvider provider) {
    return Column(
      children: [
        CommonTextWidget(
          text: 'Daily Spin Challenge',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'Spin the wheel once per day for amazing rewards!',
          fontSize: 16,
          color: Colors.grey.shade400,
          align: TextAlign.center,
        ),
        const SizedBox(height: 16),

        // User stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(
              icon: Icons.stars,
              label: 'Loyalty Points',
              value: '${provider.userLoyaltyPoints}',
              color: Colors.amber,
            ),
            _buildStatCard(
              icon: Icons.casino,
              label: 'Remaining Spins',
              value: '${provider.remainingSpins}',
              color: AppConstants.appPrimaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: value,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          CommonTextWidget(
            text: label,
            fontSize: 12,
            color: Colors.grey.shade400,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpinWheel(SpinProvider provider) {
    return SpinWheelWidget(
      options: provider.spinOptions,
      controller: provider.spinStream,
      isSpinning: provider.isSpinning,
      size: 280,
      onAnimationEnd: () => _handleSpinComplete(provider),
      onFocusItemChanged: (index) {
        // Handle focus change if needed
      },
    );
  }

  Widget _buildNoSpinAvailable() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.casino_outlined, size: 80, color: Colors.grey.shade600),
        const SizedBox(height: 16),
        CommonTextWidget(
          text: 'No spin available',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'Please check back later',
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
      ],
    );
  }

  Widget _buildActionButton(SpinProvider provider) {
    if (!provider.canSpin) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Column(
          children: [
            Icon(Icons.schedule, color: Colors.grey.shade400, size: 32),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'Daily Spin Completed',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
            CommonTextWidget(
              text: 'Come back tomorrow for another spin!',
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      );
    }

    return PrimaryButton(
      text: provider.isSpinning ? 'Spinning...' : 'Spin Now!',
      onPressed: provider.isSpinning ? null : () => _handleSpin(provider),
      backgroundColor: AppConstants.appPrimaryColor,
      textColor: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      height: 56,
      width: double.infinity,
      isLoading: provider.isSpinning,
      prefix: provider.isSpinning
          ? null
          : const Icon(Icons.casino, color: Colors.white),
    );
  }

  void _handleSpin(SpinProvider provider) {
    provider.performSpin(spinType);
  }

  void _handleSpinComplete(SpinProvider provider) {
    if (provider.lastSpinResult != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SpinResultDialog(
          result: provider.lastSpinResult!,
          canSpinAgain: false,
          onClose: () => provider.resetSpinResult(),
        ),
      );
    }
  }
}
