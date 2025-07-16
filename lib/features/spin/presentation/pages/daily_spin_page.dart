import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/spin_provider.dart';
import '../widgets/spin_error_widget.dart';
import '../widgets/spin_exhausted_widget.dart';
import '../widgets/spin_result_dialog.dart';
import '../widgets/spin_wheel_widget.dart';

class DailySpinPage extends StatefulWidget {
  const DailySpinPage({super.key});

  @override
  State<DailySpinPage> createState() => _DailySpinPageState();
}

class _DailySpinPageState extends State<DailySpinPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SpinProvider>();
      provider.initializeSpin(SpinType.daily);
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
              _buildCustomAppBar(),
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
                        onRetry: () {
                          provider.loadSpinData(forceRefresh: true);
                        },
                      );
                    }

                    // Check if daily spin is completed
                    if (provider.isDailySpinCompleted) {
                      return const SpinExhaustedWidget(
                        title: 'Daily Spin Completed',
                        message:
                            'You have already used your daily spin. Come back tomorrow for more rewards!',
                      );
                    }

                    if (!provider.hasSpinOptions) {
                      return SpinErrorWidget(
                        message: 'No spin options available',
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

  Widget _buildCustomAppBar() {
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
                  text: 'Daily Spin',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                  align: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpinContent(SpinProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.refreshSpinData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Header
            const CommonTextWidget(
              text: 'Daily Spin Challenge!',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const CommonTextWidget(
              text: 'Spin once per day and win exciting rewards',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // User Points Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  const SizedBox(width: 8),
                  CommonTextWidget(
                    text: 'Your Points: ${provider.userLoyaltyPoints}',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

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

            const SizedBox(height: 30),

            // Daily Spin Status
            if (provider.isDailySpinCompleted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.orange, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: CommonTextWidget(
                        text:
                            'Daily spin completed! Come back tomorrow for more rewards.',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Spin Button
              _buildSpinButton(provider),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSpinButton(SpinProvider provider) {
    final canSpinNow =
        provider.canSpin && !provider.isSpinning && provider.hasSpinOptions;

    String buttonText = 'Spin Now';
    if (provider.isDailySpinCompleted) {
      buttonText = 'Already Spun Today';
    } else if (provider.isSpinning) {
      buttonText = 'Spinning...';
    } else if (!provider.hasSpinOptions) {
      buttonText = 'No Options Available';
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canSpinNow ? () => _handleSpinButtonPressed(provider) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canSpinNow
              ? AppConstants.appPrimaryColor
              : Colors.grey.shade800,
          disabledBackgroundColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: canSpinNow ? 8 : 0,
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
                text: buttonText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: canSpinNow ? AppConstants.black : Colors.white54,
              ),
      ),
    );
  }

  void _handleSpinButtonPressed(SpinProvider provider) {
    if (provider.isDailySpinCompleted) {
      _showAlreadySpunMessage();
      return;
    }
    provider.spinWheel();
  }

  void _handleSpinComplete(
    BuildContext context,
    SpinProvider provider,
    int index,
  ) {
    if (index >= 0 && index < provider.spinOptions.length) {
      final option = provider.spinOptions[index];
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SpinResultDialog(
          option: option,
          onContinue: () {
            Navigator.of(context).pop();
            provider.refreshSpinData();
          },
        ),
      );
    } else {
      _showErrorMessage('Spin result error. Please try again.');
    }
  }

  void _showAlreadySpunMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('You have already spun today. Come back tomorrow!'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }
}
