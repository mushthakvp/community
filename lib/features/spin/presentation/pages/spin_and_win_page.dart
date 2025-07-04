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

class SpinAndWinPage extends StatefulWidget {
  const SpinAndWinPage({super.key});

  @override
  State<SpinAndWinPage> createState() => _SpinAndWinPageState();
}

class _SpinAndWinPageState extends State<SpinAndWinPage> {
  static const String spinType = 'spin_and_earn';

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
      appBar: CommonAppBar(
        title: 'Spin & Win',
        showBackButton: true,
        actions: [
          IconButton(
            onPressed: () => _showSpinHistory(),
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () => _toggleSound(),
            icon: Icon(
              context.watch<SpinProvider>().soundEnabled
                  ? Icons.volume_up
                  : Icons.volume_off,
            ),
          ),
        ],
      ),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            _buildHeader(provider),

            const SizedBox(height: 32),

            // Spin wheel
            _buildSpinWheelSection(provider),

            const SizedBox(height: 32),

            // Requirements info
            _buildRequirementsInfo(provider),

            const SizedBox(height: 24),

            // Action button
            _buildActionButton(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(SpinProvider provider) {
    return Column(
      children: [
        CommonTextWidget(
          text: 'Spin & Win Big!',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: 'Try your luck and win exciting prizes',
          fontSize: 16,
          color: Colors.grey.shade400,
          align: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // Points display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.appPrimaryColor.withOpacity(0.2),
                AppConstants.appPrimaryColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppConstants.appPrimaryColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.stars, color: AppConstants.appPrimaryColor, size: 24),
              const SizedBox(width: 8),
              CommonTextWidget(
                text: '${provider.userLoyaltyPoints} Points',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpinWheelSection(SpinProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: provider.hasSpinOptions
          ? SpinWheelWidget(
              options: provider.spinOptions,
              controller: provider.spinStream,
              isSpinning: provider.isSpinning,
              size: 300,
              onAnimationEnd: () => _handleSpinComplete(provider),
            )
          : _buildNoSpinAvailable(),
    );
  }

  Widget _buildNoSpinAvailable() {
    return SizedBox(
      height: 300,
      child: Column(
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
      ),
    );
  }

  Widget _buildRequirementsInfo(SpinProvider provider) {
    final requiredPoints = provider.spinConfig?.requiredPoints ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade700.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade300, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: CommonTextWidget(
              text:
                  'You need at least $requiredPoints loyalty points to spin. Each spin costs points, so play wisely!',
              fontSize: 14,
              color: Colors.blue.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(SpinProvider provider) {
    if (!provider.canSpin) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade900.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade700.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(Icons.block, color: Colors.red.shade300, size: 32),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: 'Insufficient Points',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade300,
            ),
            CommonTextWidget(
              text: 'Earn more loyalty points to spin again!',
              fontSize: 14,
              color: Colors.red.shade200,
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
          canSpinAgain: provider.canSpin,
          onSpinAgain: () => _handleSpin(provider),
          onClose: () => provider.resetSpinResult(),
        ),
      );
    }
  }

  void _showSpinHistory() {
    Navigator.pushNamed(context, '/spin-history');
  }

  void _toggleSound() {
    context.read<SpinProvider>().toggleSound();
  }
}
