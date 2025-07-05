import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/spin_provider.dart';
import '../widgets/spin_error_widget.dart';
import '../widgets/spin_result_dialog.dart';
import '../widgets/spin_wheel_widget.dart';

class SpinAndEarnPage extends StatefulWidget {
  const SpinAndEarnPage({super.key});

  @override
  State<SpinAndEarnPage> createState() => _SpinAndEarnPageState();
}

class _SpinAndEarnPageState extends State<SpinAndEarnPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpinProvider>().initializeSpin(SpinType.unlimited);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildGradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Consumer<SpinProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: LoadingWidget());
                    }

                    if (provider.hasError) {
                      return SpinErrorWidget(
                        message:
                            provider.errorMessage ?? 'Something went wrong',
                        onRetry: () =>
                            provider.loadSpinData(forceRefresh: true),
                      );
                    }

                    return _buildSpinContent(provider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Consumer<SpinProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: AppConstants.white),
              ),
              const Expanded(
                child: CommonTextWidget(
                  text: 'Spin & Earn',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                  align: TextAlign.center,
                ),
              ),
              // Points Display
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.appPrimaryColor.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.stars,
                      color: AppConstants.appPrimaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    CommonTextWidget(
                      text: '${provider.userLoyaltyPoints}',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpinContent(SpinProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          const CommonTextWidget(
            text: 'Try Your Luck and Win Big!',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppConstants.white,
            align: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const CommonTextWidget(
            text: 'Earn more loyalty points and exciting rewards',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            align: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Spin Wheel
          SizedBox(
            height: 400,
            child: SpinWheelWidget(
              options: provider.spinOptions,
              selectedStream: provider.spinStream,
              isSpinning: provider.isSpinning,
              onSpinComplete: (index) =>
                  _handleSpinComplete(context, provider, index),
            ),
          ),

          const SizedBox(height: 32),

          // Points Requirement
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
              ),
            ),
            child: CommonTextWidget(
              text:
                  'You need at least ${provider.requiredPoints} loyalty points to spin',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // Spin Button
          _buildSpinButton(provider),
        ],
      ),
    );
  }

  Widget _buildSpinButton(SpinProvider provider) {
    final canSpin = provider.canSpin && !provider.isSpinning;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canSpin ? provider.spinWheel : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canSpin
              ? AppConstants.appPrimaryColor
              : Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: canSpin ? 8 : 0,
        ),
        child: provider.isSpinning
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppConstants.black,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  CommonTextWidget(
                    text: 'Spinning...',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.black,
                  ),
                ],
              )
            : CommonTextWidget(
                text: canSpin ? 'Play' : 'Not enough points to spin',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: canSpin ? AppConstants.black : Colors.white54,
              ),
      ),
    );
  }

  void _handleSpinComplete(
    BuildContext context,
    SpinProvider provider,
    int index,
  ) {
    final option = provider.spinOptions[index];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SpinResultDialog(
        option: option,
        isUnlimited: true,
        onContinue: () {
          Navigator.of(context).pop();
          provider.loadSpinData(forceRefresh: true);
        },
        onSpinAgain: () {
          Navigator.of(context).pop();
          if (provider.canSpin) {
            provider.spinWheel();
          }
        },
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2E1A47), Color(0xFF3E2162), Color(0xFF4F287A)],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }
}
